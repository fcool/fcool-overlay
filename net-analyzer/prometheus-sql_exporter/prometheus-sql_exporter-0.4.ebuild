# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot
EGO_PN="github.com/free/sql_exporter"
EGIT_COMMIT="${PV/_rc/-rc.}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for mysql metrics"
HOMEPAGE="https://github.com/free/sql_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix sql_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin sql_exporter/sql_exporter
	dodoc README.md LICENSE VERSION documentation/sql_exporter.yml
	insinto /etc/prometheus/sql_exporter
	doins examples/sql_exporter.yml
	doins examples/mssql_standard.collector.yml
	popd || die
	keepdir /var/log/sql_exporter
	fowners ${PN}:${PN} /var/log/sql_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	dodir /etc/prometheus/sql_exporter
}
