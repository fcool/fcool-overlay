# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An email and SMTP testing tool with API for developers"
HOMEPAGE="https://github.com/axllent/mailpit"

inherit go-module

SRC_URI="https://github.com/axllent/mailpit/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-node_modules.tar.xz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"

LICENSE="MIT"
KEYWORDS="amd64 arm64"
SLOT="0"

src_compile() {
        npm run package
	ego build -ldflags "-s -w -X github.com/axllent/mailpit/config.Version=v${PV}"
}

src_install() {
	dobin "mailpit"
	newconfd "${FILESDIR}/mailpit.confd" mailpit
	newinitd "${FILESDIR}/mailpit.initd" mailpit
}
