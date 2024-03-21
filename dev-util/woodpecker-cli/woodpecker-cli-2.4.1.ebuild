# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Command-line interface for woodpecker"
HOMEPAGE="https://github.com/woodpecker-ci/woodpecker"

SRC_URI="https://github.com/woodpecker-ci/woodpecker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/woodpecker-cli-${PV}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT+=" test"
S="${WORKDIR}/woodpecker-${PV}"
src_compile() {
        CGO_ENABLED=0 ego build \
                -ldflags "-X main.version=${PV}" -o dist/woodpecker-cli go.woodpecker-ci.org/woodpecker/v2/cmd/cli
}

src_install() {
        dobin dist/woodpecker-cli
}
