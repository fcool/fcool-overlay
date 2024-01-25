# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

KEYWORDS="~amd64"
DESCRIPTION="LogCLI is the command-line interface to Grafana Loki"
HOMEPAGE="https://github.com/grafana/loki/"
SRC_URI="https://github.com/grafana/loki/archive/v${PV}.tar.gz -> loki-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
COMMON_DEPEND=""
BDEPEND=">=dev-lang/go-1.19.0"
DEPEND="${COMMON_DEPEND} !<app-admin/loki-2.9.3-r2"
RDEPEND="${COMMON_DEPEND} !<app-admin/loki-2.9.3-r2"

EGO_PN="github.com/grafana/loki"
S="${WORKDIR}/loki-$PV/"

src_compile() {
	VPREFIX="${EGO_PN}/pkg/util/build"
	EGO_BUILD_FLAGS="-X $VPREFIX.Version=$PV -X $VPREFIX.BuildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	
	ego build -ldflags "-extldflags \"-static\" -s -w $EGO_BUILD_FLAGS" -tags netgo ./cmd/logcli
	echo "$@"
	"$@" || die
}

src_install() {
	dobin "${S}/logcli"
	newenvd "${FILESDIR}/20loki" "20loki"
}

