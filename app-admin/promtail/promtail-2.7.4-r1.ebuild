# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/grafana/loki"

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Promtail sends logs to a loki instance"
HOMEPAGE="https://github.com/grafana/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="systemd"
DEPEND="systemd? ( sys-apps/systemd )"
BDEPEND=">=dev-lang/go-1.19.0"

src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check
	if use systemd; then
		CGO_ENABLED=1
	else
		CGO_ENABLED=0
	fi
	
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		CGO_ENABLED=${CGO_ENABLED} \
		go build -v -work -x ${EGO_BUILD_FLAGS} ./src/${EGO_PN}/clients/cmd/promtail
	echo "$@"
	"$@" || die
	
	sed -i "s/\/tmp\//\/var\/lib\/promtail\//" ./src/${EGO_PN}/cmd/promtail/promtail-local-config.yaml
}

src_install() {
	dobin "${S}/promtail"
	insinto /etc/promtail/
	doins ./src/${EGO_PN}/clients/cmd/promtail/promtail-local-config.yaml
	
	keepdir /var/lib/promtail
	keepdir /var/log/promtail
	
	newconfd "${FILESDIR}/promtail.confd" promtail
	newinitd "${FILESDIR}/promtail.initd" promtail
}

