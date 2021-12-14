#!/bin/bash
#
# download latest ORgnization/ProJect release
# bash get-github-latest.sh novnc noVNC

ORNAME=${1:-archlinux}
PJNAME=${2:-archlinux-dockerx}

GITHUB=https://github.com
TARTAG=Link--muted.*nofollow

rm -rf ${PJNAME}*.gz

LATEST=$(curl -s ${GITHUB}/${ORNAME}/${PJNAME}/tags | grep "${TARTAG}" -m2 | awk '{print $3}' | awk -F\" '{print $2}' | tail -n1)
echo ${GITHUB}${LATEST}

if [ -z $LATEST ]; then    # cannot get latest version link
    echo ${ORNAME} ${PJNAME}': no release'
    exit 2
fi

wget -q --no-check-certificate ${GITHUB}${LATEST}

REMTMP=`ls -tr *.gz | tail -n1`
mv $REMTMP ${PJNAME}-${REMTMP}
ls -ltr ${PJNAME}*.gz
