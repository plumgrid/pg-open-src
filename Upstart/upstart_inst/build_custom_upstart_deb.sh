# This file is part of upstart_1.5-0ubuntu7.4_amd64, a modified version of 
# upstart_1.5 used by PLUMgrid.

# Copyright (c) 2016, PLUMgrid Inc, http://plumgrid.com

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
patch -p1 < "${SRCDIR}/upstart_1.5-dbus_address.patch"
debchange -i 'Add domain socket suffix for running inside shared network lxc container'

# build the package
debuild -us -uc -i -I -b

rm -rf "${WORKDIR}"
echo "Package created successfully at: ${BLDDIR}"

exit 0
