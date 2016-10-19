#!/bin/bash

set -e
set -x

SRCDIR='/home/plumgrid/work/tools/packages/'
BLDDIR='/home/plumgrid/work/tools/build/'
WORKDIR='/home/plumgrid/work/tools/build/upstart-1.5/'

# prepare the environment to build the package
rm -rf "${WORKDIR}"
sudo apt-get build-dep upstart

# extract the original package as-is
pushd "${BLDDIR}"
tar xf "${SRCDIR}/upstart_1.5.orig.tar.gz"
zcat "${SRCDIR}/upstart_1.5-0ubuntu7.3.diff.gz" | patch -p0

# apply and document our patch(es)
pushd "${WORKDIR}"
export DEBEMAIL="PLUMgrid package bot <eng@plumgrid.com>"
patch -p1 < "${SRCDIR}/upstart_1.5-dbus_address.patch"
debchange -i 'Add domain socket suffix for running inside shared network lxc container'

# build the package
debuild -us -uc -i -I -b

rm -rf "${WORKDIR}"
echo "Package created successfully at: ${BLDDIR}"

exit 0
