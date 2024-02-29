# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

KEYWORDS="~amd64"
DESCRIPTION="Promtail sends logs to a loki instance"
HOMEPAGE="https://github.com/grafana/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> loki-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""
BDEPEND=">=dev-lang/go-1.19.0"

EGO_PN="github.com/grafana/loki"
S="${WORKDIR}/loki-$PV/"

src_compile() {
	export CGO_ENABLED=1
	
	VPREFIX="${EGO_PN}/pkg/util/build"
	EGO_BUILD_FLAGS="-X $VPREFIX.Version=$PV -X $VPREFIX.BuildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	
	ego build -ldflags "-s -w $EGO_BUILD_FLAGS" -tags= ./clients/cmd/promtail
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

