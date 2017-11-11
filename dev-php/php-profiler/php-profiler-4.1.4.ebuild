# Distributed under the terms of the GNU General Public License v2

EAPI=5
PHP_EXT_NAME="tideways"
PHP_EXT_INI="yes"
USE_PHP="php7-0 php5-6 php5-5 php5-4"
MY_PN="php-profiler-extension"
S=${WORKDIR}/${MY_PN}-${PV}

inherit php-ext-source-r2

DESCRIPTION="The Profiler extension contains functions for finding performance bottlenecks in PHP code"
HOMEPAGE="https://github.com/tideways/php-profiler-extension"
SRC_URI="https://github.com/tideways/php-profiler-extension/archive/v${PV}.tar.gz -> ${P}.tgz"
LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="amd64"
DEPEND=">=dev-lang/php-5.4 
net-misc/curl[ssl] 
dev-libs/libpcre"
RDEPEND="${DEPEND}"

src_install() {
        php-ext-source-r2_src_install

        php-ext-source-r2_addtoinifiles "tideways.api_key" ""
        php-ext-source-r2_addtoinifiles "tideways.sample_rate" "100"
        php-ext-source-r2_addtoinifiles "tideways.framework" "flow"
        php-ext-source-r2_addtoinifiles "tideways.load_library" "0"
        php-ext-source-r2_addtoinifiles "tideways.auto_prepend_library" "0"
        php-ext-source-r2_addtoinifiles "tideways.auto_start" "0"
        php-ext-source-r2_addtoinifiles "tideways.collect" "tracing"
        php-ext-source-r2_addtoinifiles "tideways.monitor" "basic"
        php-ext-source-r2_addtoinifiles "tideways.connection" "unix:///usr/local/var/run/tidewaysd.sock"
}
