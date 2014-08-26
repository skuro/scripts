#!/bin/bash

##################### User inputs ########################

# The version of the alfresco WAR file you're uploading
VERSION=${1:-VERSION_UNSET}

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

# TODO: find the files directly on the file system instead of hard coding them
ARTIFACTS=(
    alfresco-core
    alfresco-data-model
    alfresco-deployment
    alfresco-enterprise-remote-api
    alfresco-enterprise-repo
    alfresco-jlan-embed
    alfresco-mbeans
    alfresco-remote-api
    alfresco-repository
    #alfresco-wdr-deployment.jar: WTF?
    alfresco-web-client
    alfresco-web-framework-commons
)

# Some artifacts don't respect alfresco versioning
EXCEPTIONS=(
    alfresco-xmlfactory:1.0.1
)

# Some artifacts don't have a version attached at all
NOVERSION=(
    alfresco-wdr-deployment:jar
    alfresco:war
)

function file_noversion(){
    ARTIFACT_ID=${1}
    PACKAGING=${2:-jar}

    if [ ${PACKAGING} == "jar" ]
    then
        FOLDER="${BASE_DIR}/alfresco/WEB-INF"
    else
        FOLDER="${BASE_DIR}"
    fi

    FILE="${FOLDER}/${ARTIFACT_ID}.${PACKAGING}"
}

function deploy(){
    ARTIFACT_ID=${1}
    PACKAGING=${2:-jar}
    FILE=${3:-${BASE_DIR}/alfresco/WEB-INF/lib/${ARTIFACT_ID}-${VERSION}.jar}

    echo -e -n "\tDeploying ${CYAN}${ARTIFACT_ID}${NOCOLOR}"

    OUTPUT=$(mvn deploy:deploy-file \
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
    else
        echo -e "${SPACER}${RED}FAIL${NOCOLOR}"
        echo -e "Maven output:"
        echo -e ${OUTPUT}
    fi
}

function parse_exception(){
    BACKUP=$IFS
    IFS=":"
    read -ra PARTS <<< "$1"
    IFS=${BACKUP}

    ARTF=${PARTS[0]}
    VERSION=${PARTS[1]}
}

function parse_noversion(){
    BACKUP=$IFS
    IFS=":"
    read -ra PARTS <<< "$1"
    IFS=${BACKUP}

    ARTF=${PARTS[0]}
    PACKAGING=${PARTS[1]}
}

echo -e "Uploading ${CYAN}Alfresco v${VERSION}${NOCOLOR} JARs to repo ${TARGET_REPO} at ${TARGET_REPO_URL}"

echo
for ARTF in ${ARTIFACTS[@]}
do
    deploy ${ARTF}
done

for ARTF in ${EXCEPTIONS[@]}
do
    parse_exception "$ARTF"
    deploy ${ARTF}
done

for ARTF in ${NOVERSION[@]}
do
    parse_noversion ${ARTF}
    file_noversion ${ARTF} ${PACKAGING}
    deploy ${ARTF}
done
