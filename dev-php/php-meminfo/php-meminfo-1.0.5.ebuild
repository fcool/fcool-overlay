# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/rc/RC}"
USE_PHP="php7-0 php7-1 php7-2"
PHP_EXT_NAME="meminfo"
S=${WORKDIR}/${PN}-${PV}/extension/php7

inherit php-ext-source-r3

SRC_URI="https://github.com/BitOne/php-meminfo/archive/v${PV}.tar.gz -> ${P}.tgz"

KEYWORDS="amd64 x86"

DESCRIPTION="Extension exposing memory information"
LICENSE="MIT"
SLOT="0"
IUSE="examples test"


