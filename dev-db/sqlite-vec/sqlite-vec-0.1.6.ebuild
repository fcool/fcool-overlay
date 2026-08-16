# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for sqlite-vec"
HOMEPAGE="
	https://github.com/asg017/sqlite-vec
	https://pypi.org/project/sqlite-vec/
"
LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

SRC_URI="
	https://files.pythonhosted.org/packages/80/76/97f33b1a2446f6ae55e59b33869bed4eafaf59b7f4c662c8d9491b6a714a/sqlite_vec-0.1.6-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux1_x86_64.whl \
		-> sqlite_vec-0.1.6-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux1_x86_64.whl
"
S=${WORKDIR}

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" "${DISTDIR}/${A}"
}
