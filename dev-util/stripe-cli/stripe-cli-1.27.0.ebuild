# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A command-line tool for Stripe (Payment Gateway)"
HOMEPAGE="https://github.com/stripe/stripe-cli"

inherit go-module

SRC_URI="https://github.com/stripe/stripe-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"

LICENSE="MIT"
KEYWORDS="amd64 arm64"
SLOT="0"

src_compile() {
	#ego build -ldflags "-s -w -X github.com/stripe/stripe-cli/config.Version=v${PV}"
	emake
}

src_install() {
	dobin "stripe"
}
