#!/bin/sh

NEW_ENTITY=$1

NEW_ENTITY_LC=`echo $NEW_ENTITY | perl -e "print lcfirst(<>);"`

cp StatBannerBrowserId.java StatBanner${NEW_ENTITY}Id.java

sed -i '' -e "s/Browser/$NEW_ENTITY/g"  StatBanner${NEW_ENTITY}Id.java
sed -i '' -e "s/browser/$NEW_ENTITY_LC/g"  StatBanner${NEW_ENTITY}Id.java

#sed -i '' -e "s/\@Entity/\@IdClass\(\StatBanner${NEW_ENTITY}Id.class\)
#\@Entity/" StatBanner${NEW_ENTITY}Entity.java

perl -pi -e "s/import/import javax.persistence.IdClass;\nimport javax.persistence.Id;\nimport/" StatBanner${NEW_ENTITY}Entity.java
perl -pi -e "s/\@Entity/\@IdClass\(\StatBanner${NEW_ENTITY}Id.class\)\n\@Entity/" StatBanner${NEW_ENTITY}Entity.java
perl -pi -e "s/public int getBanner/\@Id\npublic int getBanner/" StatBanner${NEW_ENTITY}Entity.java
perl -pi -e "s/public String get${NEW_ENTITY}/\@Id\npublic String get${NEW_ENTITY}/" StatBanner${NEW_ENTITY}Entity.java

#sed -i '' -e "s/public int getBanner/\@Id\
#public int getBanner"  StatBanner${NEW_ENTITY}Entity.java
