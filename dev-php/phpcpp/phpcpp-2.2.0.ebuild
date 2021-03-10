# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PHP_EXT_SKIP_PHPIZE="yes"
PHP_EXT_NAME="libphpcpp"
PHP_EXT_INI="no"
USE_PHP="php7-2 php7-3 php7-4"
MY_PN="PHP-CPP"
S=${WORKDIR}/${MY_PN}-${PV}

inherit eutils php-ext-source-r3

DESCRIPTION="The PHP-CPP library is a C++ library for developing PHP extensions"
HOMEPAGE="http://www.php-cpp.com/"

SRC_URI="https://github.com/CopernicaMarketingSoftware/PHP-CPP/archive/v${PV}.tar.gz -> ${P}.tgz"
LICENSE="Apache-2.0"

SLOT="1"

KEYWORDS="amd64"
DEPEND="php_targets_php7-2? ( dev-lang/php:7.2 ) php_targets_php7-3? ( dev-lang/php:7.3 ) php_targets_php7-4? ( dev-lang/php:7.4 )"
#RDEPEND="${DEPEND}"
PATCHES=(
    "${FILESDIR}"/noldconfig-2.patch
    "${FILESDIR}"/php7.4.patch
)

src_configure() {
    echo ""
}

my_slot_env() {
	php_init_slot_env $@
	export PHP_CONFIG="${PHPCONFIG}"
	export INSTALL_PREFIX="${D}${PHPPREFIX}"
	export INSTALL_HEADERS="${D}${PHPPREFIX}/include"
	export INSTALL_LIB="${D}${PHPPREFIX}/$(get_libdir)"
	export CFLAGS
	export LINKER_FLAGS="-shared ${LDFLAGS}"
}

src_compile() {
        local slot
        for slot in $(php_get_slots); do
                my_slot_env ${slot}
		sed -e"s/\-c \-g/-c ${CFLAGS}/" -i Makefile
                emake -e || die "Unable to make code"
        done
}

src_install() {
	local slot
        for slot in $(php_get_slots); do
                my_slot_env ${slot}
		mkdir -p ${INSTALL_LIB}
                emake -e install
        done
}
