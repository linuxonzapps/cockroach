#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Extract DISTRO details for tagging
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID-$VERSION_ID"
    if [ "$VERSION_CODENAME" != "" ]; then
        DISTRO="$ID-$VERSION_CODENAME"
    fi
fi
current_dir="$PWD"
echo $DISTRO > .distro_zab.txt
bash /tmp/linux-on-ibm-z-scripts/CockroachDB/${version}/build_crdb.sh -y
tar cvfz cockroach-${version}-linux-s390x.tar.gz -C /usr/local/bin cockroach -C /usr/local/lib cockroach
exit 0
