# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
MY_PV="v${PV/_rc/-rc.}"

DESCRIPTION="php-fpm prometheus exporter"
HOMEPAGE="https://github.com/hipages/php-fpm_exporter"

SRC_URI="https://github.com/hipages/php-fpm_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
https://digital-competence.de/php-fpm_exporter/${P}-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

#S="${WORKDIR}/${PN}-${PV/_rc/-rc.}"

src_compile() {
        ego build \
                -ldflags "-X main.version=${PV}"
}

src_install() {
        dobin php-fpm_exporter
        dodoc README.md
        newconfd "${FILESDIR}/${PN}.confd" ${PN}
        newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
