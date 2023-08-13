# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Command-line interface for woodpecker"
HOMEPAGE="https://github.com/woodpecker-ci/woodpecker"

SRC_URI="https://github.com/woodpecker-ci/woodpecker/archive/v${PV}.tar.gz -> ${P}.tar.gz https://digital-competence.de/woodpecker-cli/woodpecker-cli-1.0.1-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT+=" test"
S="${WORKDIR}/woodpecker-${PV}"
src_compile() {
        ego build \
                -ldflags "-X main.version=${PV}" -o dist/woodpecker-cli github.com/woodpecker-ci/woodpecker/cmd/cli
}

src_install() {
        dobin dist/woodpecker-cli
}
