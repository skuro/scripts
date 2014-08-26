#!/bin/bash
##########################################################
#
# Automatic deployment of your Alfresco artifacts
#
# Requires the following file structure:
#
# ${BASE_DIR}/alfresco.war
# ${BASE_DIR}/alfresco/WEB-INF/lib/...
# ${BASE_DIR}/share.war
# ${BASE_DIR}/share/WEB-INF/lib/...
#
# @author  Carlo Sciolla <skuro@skuro.tk>
# @version 1.0
##########################################################

##################### User inputs ########################

# The version of the alfresco WAR file you're uploading
ALF_VERSION=${1:-VERSION_UNSET}

# The ID of the remote repository, to match with your maven settings
TARGET_REPO=${2:-REPO_UNSET}

# The URL of the remote repository, defaults to the local repo
TARGET_REPO_URL=${3:-file://$HOME/.m2/repository}

# Where the alfresco.war and alfresco/ folder are located
BASE_DIR=${4:-.}

# Specify 'community' or 'enterprise' here to choose the proper maven coordinates
RELEASE=${5:-enterprise}

##########################################################

CYAN="\033[0;36m"
NOCOLOR="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"

SPACER="\033[60G"

if [ "$RELEASE" == "enterprise" ]
then
    GROUP_ID="org.alfresco.enterprise"
else
    GROUP_ID="org.alfresco"
fi

##
## Used to track what artifacts were deployed by this program execution
##
DEPLOYED_SO_FAR=()

##
## Checks whether an element is found in an array
## Curtesy of http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
##
contains_element () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

##
## Checks whether the given artifacts was already deployed during this program execution
##
function already_deployed(){
    ARTIFACT=${1}
    contains_element "${ARTIFACT}" "${DEPLOYED_SO_FAR[@]}"
}

##
## Deploys an artifact via maven using the provided coordinates and repo config.
## If a file was already deployed during this program execution it will be skipped.
##
function deploy(){
    local ARTIFACT_ID=${1}
    local PACKAGING=${2:-jar}
    local VERSION=${3:-${ALF_VERSION}}
    local FILE=${4:-${BASE_DIR}/alfresco/WEB-INF/lib/${ARTIFACT_ID}-${VERSION}.jar}

    already_deployed ${ARTIFACT_ID} > /dev/null 2>&1
    local IS_DEPLOYED=${?}
    if [[ ${IS_DEPLOYED} -eq 0 ]]
    then
        : # skipping an already deployed artifact
    elif [[ -f ${FILE} ]]
    then
        echo -e -n "\tDeploying ${CYAN}${ARTIFACT_ID}${NOCOLOR}"

        local OUTPUT=$(mvn deploy:deploy-file \
            -Dfile="${FILE}" \
            -DrepositoryId="${TARGET_REPO}" \
            -DgroupId="${GROUP_ID}" \
            -DartifactId="${ARTIFACT_ID}" \
            -Dversion="${VERSION}" \
            -Durl="${TARGET_REPO_URL}" \
            -Dpackaging="${PACKAGING}"  \
            -Dclassifier="${RELEASE}" 2>&1)

        if [ ${?} -eq 0 ]
        then
            echo -e "${SPACER}${GREEN}OK${NOCOLOR}"
            DEPLOYED_SO_FAR+=(${ARTIFACT_ID})
        else
            echo -e "${SPACER}${RED}FAIL${NOCOLOR}"
            echo -e "Maven output:"
            echo -e ${OUTPUT}
        fi
    else
        echo -e "${RED}File not found: ${FILE}${NOCOLOR}"
    fi
}

##
## Discovers inner alfresco-* JARs inside a given exploded APP and deploys them.
## It recognizes both the following naming formats:
## - alfresco-[my-lib-name]-x.x.x.x.jar
## - alfresco-[my-lib-with-no-version].jar
##
function deploy_libraries(){
    local APP=${1}

    local FULL_REGEX="(alfresco-[a-zA-Z\-]+)-([0-9\.]+).jar"
    local NOVERSION_REGEX="(alfresco-[a-zA-Z\-]+).jar"
    for LIB_PATH in `ls ${BASE_DIR}/${APP}/WEB-INF/lib/alfresco*`
    do
        local LIB=`basename $LIB_PATH`
        local VERSION=${ALF_VERSION}
        if [[ $LIB =~ $FULL_REGEX ]]
        then
            local VERSION=${BASH_REMATCH[2]}
        elif [[ $LIB =~ ${NOVERSION_REGEX} ]]
        then
            : # NOOP, just needed to run the regex to populate ${BASH_REMATCH[]}
        fi
        deploy ${BASH_REMATCH[1]} "jar" ${VERSION} ${LIB_PATH}
    done
}

##
## Capitalizes the first letter of the provided token
##
function uppercase(){
    TOKEN="${1}"
    echo $(echo ${TOKEN:0:1} | tr '[a-z]' '[A-Z]')${TOKEN:1}
}

##
## Deploys a WAR file and its inner alfresco-* JARs
##
function deploy_app(){
    local APP=${1}
    local APP_CAPITAL=$(uppercase ${APP})
    echo -e "Uploading ${CYAN}${APP_CAPITAL} v${ALF_VERSION}${NOCOLOR} artifacts to repo ${TARGET_REPO} at ${TARGET_REPO_URL}"
    deploy_libraries ${APP}
    deploy ${APP} "war" ${ALF_VERSION} "${APP}.war"
}

for APP in alfresco share
do
    deploy_app ${APP}
done
