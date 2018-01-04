# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/mysqld_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for mysql metrics"
HOMEPAGE="https://github.com/prometheus/mysqld_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

#src_prepare() {
#	default
#	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
#}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix mysqld_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin mysqld_exporter/mysqld_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	popd || die
	keepdir /var/lib/mysqld_exporter /var/log/mysqld_exporter
	fowners ${PN}:${PN} /var/lib/mysqld_exporter /var/log/mysqld_exporter
	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
