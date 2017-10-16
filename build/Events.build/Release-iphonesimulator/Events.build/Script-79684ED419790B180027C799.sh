#!/bin/sh
#if [ ${CONFIGURATION} == "Release" ]; then
APPLEDOC_PATH=`which appledoc`
if [ $APPLEDOC_PATH ]; then
$APPLEDOC_PATH \
--project-name ${PRODUCT_NAME} \
--project-company "Your Name" \
--company-id "com.yourcompany" \
--output ${PRODUCT_NAME}Docs \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--exit-threshold 2 \
${PROJECT_DIR}/${PRODUCT_NAME}
fi;
#fi;
