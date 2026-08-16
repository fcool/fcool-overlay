# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="SSE plugin for Starlette"
HOMEPAGE="https://github.com/sysid/sse-starlette"

SRC_URI="https://files.pythonhosted.org/packages/3c/54/9651ca960c0fbb997fb2a69dc01b29b182c643eb42a59b82623f7716054a/sse_starlette-2.0.0.tar.gz"
S="${WORKDIR}/sse-starlette-2.0.0"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~x86"
