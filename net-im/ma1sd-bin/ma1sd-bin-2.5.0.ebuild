# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Federated Matrix Identity Server (formerly fork of kamax/mxisd)"
HOMEPAGE="https://github.com/ma1uta/ma1sd"
SRC_URI="https://github.com/ma1uta/ma1sd/releases/download/${PV}/ma1sd.zip -> ${P}.zip"
LICENSE="AGPL-3"
KEYWORDS="amd64"
SLOT="2.5"

RESTRICT="test"

DEPEND=">=virtual/jdk-1.8:*
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/ma1sd"

src_compile () {
    :
}

src_install () {
    java-pkg_dojar lib/*.jar
    java-pkg_dolauncher ma1sd --main io.kamax.mxisd.MxisdStandaloneExec ma1sd.jar
    newconfd "${FILESDIR}/ma1sd.confd" ma1sd
    newinitd "${FILESDIR}/ma1sd.initd" ma1sd
    mkdir -p etc/ma1sd
    insinto etc/ma1sd
    doins "${FILESDIR}/ma1sd.yaml.example"
}
