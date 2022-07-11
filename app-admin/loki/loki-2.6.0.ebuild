# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/grafana/loki"

inherit user golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Like Prometheus, but for logs."
HOMEPAGE="https://github.com/grafana/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
BDEPEND="
	=dev-lang/go-1.17*
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}


src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check
	
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go build -v -work -x ${EGO_BUILD_FLAGS} ./src/${EGO_PN}/cmd/loki
	echo "$@"
	"$@" || die
	mv loki ${T}/loki
	
	sed -i "s/\/tmp\/loki/\/var\/lib\/loki/" ./src/${EGO_PN}/cmd/loki/loki-local-config.yaml

        set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go build -v -work -x ${EGO_BUILD_FLAGS} ./src/${EGO_PN}/cmd/logcli
	echo "$@"
	"$@" || die
	mv logcli ${T}
}

src_install() {

	dobin "${T}/loki"
	dobin "${T}/logcli"
	
	insinto /etc/loki/
	doins ./src/${EGO_PN}/cmd/loki/loki-local-config.yaml
	
	keepdir /var/lib/loki/index /var/lib/loki/chunks /var/log/loki
	fowners ${PN}:${PN} /var/lib/loki /var/lib/loki/index /var/lib/loki/chunks /var/log/loki
	
	newconfd "${FILESDIR}/loki.confd" loki
	newinitd "${FILESDIR}/loki.initd" loki
}


