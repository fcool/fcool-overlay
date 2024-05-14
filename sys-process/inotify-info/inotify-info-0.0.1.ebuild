# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Linux inotify info reporting app"

HOMEPAGE="https://github.com/mikesart/inotify-info"
SRC_URI="https://github.com/mikesart/inotify-info/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64 arm64"
SLOT="0"

src_install() {
	dobin "_release/inotify-info"
}
