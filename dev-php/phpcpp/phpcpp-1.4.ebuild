# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PHP_EXT_SKIP_PHPIZE="yes"
PHP_EXT_NAME="libphpcpp"
PHP_EXT_INI="no"
USE_PHP="php5-5 php5-4"
MY_PN="PHP-CPP"
S=${WORKDIR}/${MY_PN}-${PV}


inherit php-ext-source-r2
#inherit eutils
# A well-used example of an eclass function that needs eutils is epatch. If
# your source needs patches applied, it's suggested to put your patch in the
# 'files' directory and use:
#
#   epatch "${FILESDIR}"/patch-name-here
#
# eclasses tend to list descriptions of how to use their functions properly.
# take a look at /usr/portage/eclass/ for more examples.

DESCRIPTION="The PHP-CPP library is a C++ library for developing PHP extensions"
HOMEPAGE="http://www.php-cpp.com/"

#SRC_URI="https://api.github.com/repos/CopernicaMarketingSoftware/PHP-CPP/tarball/v${PV}  -> ${P}.tgz"
SRC_URI="https://github.com/CopernicaMarketingSoftware/PHP-CPP/archive/v${PV}.tar.gz -> ${P}.tgz"
LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="amd64"
#DEPEND=">=dev-lang/php-5.4"
#RDEPEND="${DEPEND}"

src_configure() {
	echo "ready"
}

my_slot_env() {
	php_init_slot_env $@
	export PHPPREFIX="${EPREFIX}/usr/${libdir}/${slot}"
	export PHP_CONFIG="${PHPCONFIG}"
	export INSTALL_PREFIX="${D}${PHPPREFIX}"
	export INSTALL_HEADERS="${D}${PHPPREFIX}/include"
	export INSTALL_LIB="${D}${PHPPREFIX}/$(get_libdir)"
	export CFLAGS
	export LINKER_FLAGS="-shared ${LDFLAGS}"
}

src_compile() {
        # net-snmp creates this file #324739
        addpredict /usr/share/snmp/mibs/.index
        addpredict /var/lib/net-snmp/mib_indexes

        # shm extension createss a semaphore file #173574
        addpredict /session_mm_cli0.sem
        local slot
        for slot in $(php_get_slots); do
                my_slot_env ${slot}
		sed -e"s/\-c \-g/-c ${CFLAGS}/" -i Makefile
                emake -e || die "Unable to make code"
        done
	mkdir modules
	cp ${PHP_EXT_NAME}.so modules
}

src_install() {
	local slot
        for slot in $(php_get_slots); do
                my_slot_env ${slot}
		mkdir -p ${INSTALL_LIB}
                emake -e install
        done
}
