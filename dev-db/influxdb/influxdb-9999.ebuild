# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit golang-build

DESCRIPTION="Web toolset for administrating servers"
HOMEPAGE="http://influxdb.com/"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

# Spec.in says these are dependencies:
#python-gevent, python-greenlet, python-lxml, openssl, python-gevent-socketio, python-gevent-websocket, python-psutil >= 0.6.0, python-imaging, python-daemon, python-passlib, python-requests, reconfigure >= 0.1.43, python-catcher, python-exconsole >= 0.1.5, python-ldap

DEPEND="dev-lang/go"
EGO_PN="github.com/influxdb/influxdb/..."
EGO_SRC="github.com/influxdb/influxdb"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	SRC_URI="https://github.com/influxdb/influxdb/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

src_compile() {
	set -- env GOPATH="${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo:${EGO_STORE_DIR}" \
                go build -v -work -x "${EGO_PN}"
	echo "$@"
        "$@" || die
}

src_install() {
	set -- env GOPATH="${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo:${EGO_STORE_DIR}" \
                go install -v -work -x "${EGO_PN}"
        echo "$@"
        "$@" || die
        insinto /usr/lib/go-gentoo
        insopts -m0644 -p # preserve timestamps for bug 551486
        doins -r pkg src
	dobin bin/influx*
}
