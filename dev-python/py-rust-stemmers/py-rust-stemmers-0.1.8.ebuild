# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )
DISTUTILS_USE_PEP517=no
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Fast parallel snowball stemmer"
HOMEPAGE="https://pypi.org/project/py-rust-stemmers/"
SRC_URI="https://files.pythonhosted.org/packages/06/59/8211cd0f56e53f7770debd9a78de37985fb5662ae66e3b7b380f4c79888b/py_rust_stemmers-0.1.8-cp314-cp314-manylinux_2_17_x86_64.manylinux2014_x86_64.whl \
	-> py_rust_stemmers-0.1.8-cp314-cp314-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
"

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" "${DISTDIR}/${A}"
}
