# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/rc/RC}"
USE_PHP="php7-4 php8-0 php8-1 php8-2"
PHP_EXT_NAME="ast"

inherit php-ext-source-r3

SRC_URI="https://github.com/nikic/php-ast/archive/v${PV}.tar.gz -> ${P}.tgz"
HOMEPAGE="https://github.com/nikic/php-ast/"

KEYWORDS="amd64 x86"

DESCRIPTION="Extension exposing PHP 7 abstract syntax tree"
LICENSE="MIT"
SLOT="0"
IUSE="examples test"
