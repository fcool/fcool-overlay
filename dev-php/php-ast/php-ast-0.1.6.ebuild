# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/rc/RC}"
USE_PHP="php7-0 php7-1 php7-2"
PHP_EXT_NAME="ast"

inherit php-ext-source-r3

SRC_URI="https://github.com/nikic/php-ast/archive/v${PV}.tar.gz -> ${P}.tgz"

KEYWORDS="amd64 x86"

DESCRIPTION="Extension exposing PHP 7 abstract syntax tree"
LICENSE="MIT"
SLOT="0"
IUSE="examples test"

# imagemagick[-openmp] is needed wrt bug 547922 and upstream
# https://github.com/mkoppanen/imagick#openmp
#RDEPEND=">=media-gfx/imagemagick-6.2.4:=[-openmp]"
#DEPEND="${RDEPEND}
#        test? ( >=media-gfx/imagemagick-6.2.4:=[jpeg,png,truetype] )"

#PHP_EXT_ECONF_ARGS="--with-imagick=${EPREFIX}/usr"

