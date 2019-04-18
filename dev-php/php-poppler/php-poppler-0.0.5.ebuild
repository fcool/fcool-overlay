# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PHP_EXT_SKIP_PHPIZE="yes"
PHP_EXT_NAME="php-poppler"
PHP_EXT_INI="yes"
USE_PHP="php5-6 php5-5 php5-4"
MY_PN="php-poppler"
S=${WORKDIR}/${MY_PN}


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

DESCRIPTION="The php-poppler is a binding to the poppler pdf library"
HOMEPAGE="http://www.digital-competence.de/php-poppler"

#SRC_URI="https://api.github.com/repos/CopernicaMarketingSoftware/PHP-CPP/tarball/v${PV}  -> ${P}.tgz"
SRC_URI="http://www.digital-competence.de/php-poppler/${P}.tgz"
LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="amd64"
DEPEND=">=dev-php/phpcpp-1.3.1 >=app-text/poppler-0.74[png,tiff] php_targets_php5-6? ( dev-php/phpcpp[php_targets_php5-6] ) php_targets_php5-5? ( dev-php/phpcpp[php_targets_php5-5] ) php_targets_php5-4? ( dev-php/phpcpp[php_targets_php5-4] )"
RDEPEND="${DEPEND}"

src_configure() {
	echo "ready"
}

my_slot_env() {
	php_init_slot_env $@
	export PHP_CONFIG="${PHPCONFIG}"
	export INSTALL_PREFIX="${D}${PHPPREFIX}"
	export INSTALL_HEADERS="${D}${PHPPREFIX}/include"
	export INSTALL_LIB="${D}${PHPPREFIX}/$(get_libdir)"
	export CFLAGS
	export LINKER_FLAGS="-shared -Wl,-rpath,\"$(${PHP_CONFIG} --prefix)/lib64\" -Wl,--no-undefined ${LDFLAGS}"
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
		mkdir modules
		mv *.so modules/

		insinto "${EXT_DIR}"
		newins "modules/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so" || die "Unable to install extension"
		# Let's put the default module away
                # emake -e install
        done
	php-ext-source-r2_createinifiles
}
