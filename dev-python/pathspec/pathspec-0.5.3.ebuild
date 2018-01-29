# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION=" Utility library for gitignore style pattern matching of file paths."

HOMEPAGE="https://github.com/cpburnz/python-path-specification"
SRC_URI="https://github.com/cpburnz/python-path-specification/archive/303b339735e9b706a6278c204ee544d208309529.zip -> ${P}.zip"
LICENSE="MPL 2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

src_unpack() {
	unpack ${A}

	mv python-path-specification-303b339735e9b706a6278c204ee544d208309529/ ${P}
}
