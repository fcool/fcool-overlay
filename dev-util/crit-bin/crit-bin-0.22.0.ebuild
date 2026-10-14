# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Review and comment on code changes and generated outputs"
HOMEPAGE="https://github.com/tomasz-tomczyk/crit"

SRC_URI="
	https://github.com/tomasz-tomczyk/crit/releases/download/v${PV}/crit-linux-amd64 -> crit-linux-amd64-${PV}
	https://github.com/tomasz-tomczyk/crit/releases/download/v${PV}/crit-linux-arm64 -> crit-linux-arm64-${PV}
	https://github.com/tomasz-tomczyk/crit/releases/download/v${PV}/checksums.txt -> checksums.txt
	https://raw.githubusercontent.com/tomasz-tomczyk/crit/v${PV}/README.md -> README.md
"

S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/crit"

src_unpack() {
	if [ "${ARCH}" = "amd64" ]; then
		cp "${DISTDIR}/crit-linux-amd64-${PV}" "${S}/crit"
	else
		cp "${DISTDIR}/crit-linux-arm64-${PV}" "${S}/crit"
	fi
	cp "${DISTDIR}/checksums.txt" "${S}/checksums.txt"
	cp "${DISTDIR}/README.md" "${S}/README.md"
}

src_install() {
	newbin crit crit
	dodoc README.md
}