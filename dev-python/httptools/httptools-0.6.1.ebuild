# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10,11,12} )
LLHTTP_COMMIT='caed04d6c1251e54c642bddfc7d0330af234f0d3'

inherit distutils-r1

DESCRIPTION="Fast HTTP Parser"
HOMEPAGE="https://github.com/MagicStack/httptools"
SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/nodejs/llhttp/archive/${LLHTTP_COMMIT}.tar.gz -> llhttp-${LLHTTP_COMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
RESTRICT="test" # tests dont find the cython modules

DEPEND="
	${PYTHON_DEPS}
	net-libs/http-parser
"
RDEPEND="${DEPEND}"

BDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	${DISTUTILS_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -e "s:../../vendor/http-parser/http_parser.h:${EPREFIX}/usr/include/http_parser.h:" -i ${PN}/parser/cparser.pxd || die
	sed -e 's/Cython(>=0\.29\.24,<0\.30\.0)/Cython>=0.29.24/' -i setup.py || die
	cp -r "${WORKDIR}/llhttp-${LLHTTP_COMMIT}"/* "${S}"/vendor/llhttp/ || die
	default
}

src_configure() {
	cat >> setup.cfg <<-EOF
		[build_ext]
		use_system_http_parser = True
	EOF
	default
}
