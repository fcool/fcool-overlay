# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

KEYWORDS="~amd64"
DESCRIPTION="Like Prometheus, but for logs."
HOMEPAGE="https://github.com/grafana/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> loki-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
COMMON_DEPEND="acct-group/loki
        acct-user/loki"
BDEPEND=">=dev-lang/go-1.19.0"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
        app-admin/logcli"


EGO_PN="github.com/grafana/loki"
S="${WORKDIR}/loki-$PV/"

src_compile() {
	VPREFIX="${EGO_PN}/pkg/util/build"
	EGO_BUILD_FLAGS="-X $VPREFIX.Version=$PV -X $VPREFIX.BuildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	
	sed -i "s/\/tmp\/loki/\/var\/lib\/loki/" ./cmd/loki/loki-local-config.yaml
	
	ego build -ldflags "-extldflags \"-static\" -s -w $EGO_BUILD_FLAGS" -tags netgo ./cmd/loki
	echo "$@"
	"$@" || die
}

src_install() {
	dobin "${S}/loki"
	
	insinto /etc/loki/
	doins ./cmd/loki/loki-local-config.yaml
	
	keepdir /var/lib/loki/index /var/lib/loki/chunks /var/log/loki
	fowners ${PN}:${PN} /var/lib/loki /var/lib/loki/index /var/lib/loki/chunks /var/log/loki
	
	newconfd "${FILESDIR}/loki.confd" loki
	newinitd "${FILESDIR}/loki.initd" loki
}

