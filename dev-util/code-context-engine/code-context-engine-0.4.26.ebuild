# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Local AI coding context search and MCP server"
HOMEPAGE="
	https://github.com/elara-labs/code-context-engine
	https://pypi.org/project/code-context-engine/
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+local"

RESTRICT="test"

# NOTE: the "local" embedding extra (dev-python/fastembed) needs
# sci-libs/onnxruntime[python], which is only available from ::guru.

# Upstream caps tree-sitter at <0.26 only for its PyPI wheels, which ship
# their own bundled core and crash when grammar wheels lag behind. Here
# dev-python/tree-sitter and the grammar packages are all built against
# the shared dev-libs/tree-sitter, so no upper bound is needed (and
# pinning <0.26 conflicts with e.g. dev-util/pkgcheck).
RDEPEND="
	local? ( >=dev-python/fastembed-0.4.0[${PYTHON_USEDEP}] )
	>=dev-python/aiohttp-3.9.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.0[${PYTHON_USEDEP}]
	>=dev-python/fastapi-0.110.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.0.0[${PYTHON_USEDEP}]
	<dev-python/mcp-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.24.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.9.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.0[${PYTHON_USEDEP}]
	>=dev-db/sqlite-vec-0.1.6
	>=dev-python/tree-sitter-0.22.0[${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-c-sharp-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-go-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-java-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-javascript-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-php-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-python-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-rust-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-libs/tree-sitter-typescript-0.23.0[python,${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.29.0[${PYTHON_USEDEP}]
	>=dev-python/watchdog-4.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/setuptools-68.0[${PYTHON_USEDEP}]
"
