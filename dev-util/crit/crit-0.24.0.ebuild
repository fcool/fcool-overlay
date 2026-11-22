# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Review and comment on code changes and generated outputs"
HOMEPAGE="https://github.com/tomasz-tomczyk/crit"

inherit go-module

SRC_URI="https://github.com/tomasz-tomczyk/crit/archive/v${PV}.tar.gz -> crit-${PV}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-node_modules.tar.xz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"

LICENSE="MIT"
SLOT="0" # dev-util/crit-bin also installs /usr/bin/crit, install only one
KEYWORDS="~amd64 ~arm64"
RESTRICT="network test" # vendor and node_modules distfiles make the build hermetic
COMMON_DEPEND=""
BDEPEND="
	>=dev-lang/go-1.26.0
	>=net-libs/nodejs-24
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	# npm writes its cache below HOME, which is read-only in the build
	# sandbox, so keep it in the build tree.
	export npm_config_cache="${WORKDIR}/.npm-cache"

	# The Makefile target prefixes this with npm install, which would
	# contact the registry; node_modules is vendored, so run the asset
	# copy directly. It has to run before the codegen, which hashes it.
	npm run update-deps
	ego generate ./...
	ego build \
		-ldflags "-s -w -X main.version=${PV}" \
		-o dist/crit \
		./cmd/crit
}

src_install() {
	dodoc README.md
	newbin dist/crit crit
}
