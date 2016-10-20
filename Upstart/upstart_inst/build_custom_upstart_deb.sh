#
# Copyright (c) 2016, PLUMgrid Inc, http://plumgrid.com
#
# This file is part of upstart_1.5-0ubuntu7.4_amd64, a modified version of 
# upstart_1.5 used by PLUMgrid.
# upstart_1.5-0ubuntu7.4_amd64 is a free software; you can redistribute it and/or modify
# it under the terms of The GNU Lesser General Public License (LGPL), version 2.1, as 
# published by the Free Software Foundation.
# You may obtain a copy of the License at
#
#     LGPL v2.1: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
