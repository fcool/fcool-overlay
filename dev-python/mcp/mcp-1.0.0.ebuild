# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Client and server code for the Model Context Protocol"
HOMEPAGE="
	https://modelcontextprotocol.io
	https://pypi.org/project/mcp/
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/anyio-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-sse-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/sse-starlette-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.39.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/setuptools-68.0[${PYTHON_USEDEP}]
"
