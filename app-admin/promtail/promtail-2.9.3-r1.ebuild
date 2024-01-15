# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

KEYWORDS="~amd64"
DESCRIPTION="Promtail sends logs to a loki instance"
HOMEPAGE="https://github.com/grafana/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="systemd"
DEPEND="systemd? ( sys-apps/systemd )"
BDEPEND=">=dev-lang/go-1.19.0"

EGO_PN="github.com/grafana/loki"
S="${WORKDIR}/loki-$PV/"

src_compile() {
	if use systemd; then
		export CGO_ENABLED=1
	else
		export CGO_ENABLED=0
	fi
	VPREFIX="${EGO_PN}/pkg/util/build"
	EGO_BUILD_FLAGS="-X $VPREFIX.Version=$PV -X $VPREFIX.BuildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	
	ego build -ldflags "-s -w $EGO_BUILD_FLAGS" -tags netgo ./clients/cmd/promtail
	echo "$@"
	"$@" || die
}

src_install() {
	dobin "${S}/promtail"
	insinto /etc/promtail/
	doins ./clients/cmd/promtail/promtail-local-config.yaml
	
	keepdir /var/lib/promtail
	keepdir /var/log/promtail
	
	newconfd "${FILESDIR}/promtail.confd" promtail
	newinitd "${FILESDIR}/promtail.initd" promtail
}

