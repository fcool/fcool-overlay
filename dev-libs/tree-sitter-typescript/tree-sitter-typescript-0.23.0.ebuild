# Copyright
EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
TS_BINDINGS=( python )

inherit tree-sitter-grammar

_get_tsg_abi_ver() {
	local parser_c
	for parser_c in "${S}"/typescript/src/parser.c "${S}"/tsx/src/parser.c; do
		[[ -f ${parser_c} ]] || continue
		sed -n 's/#define LANGUAGE_VERSION //p' "${parser_c}" | sed -n '1p' && return
	done
	die "Unable to extract ABI version for this grammar"
}

tree-sitter-grammar_src_prepare() {
	default
	sed -i 's|^LANGUAGE_NAME := tree-sitter-typescript|LANGUAGE_NAME ?= tree-sitter-typescript|' "${S}"/common/common.mak
	sed -i 's|install -m644 bindings/c/|install -m644 ../bindings/c/|' "${S}"/common/common.mak
}

DESCRIPTION="Tree-sitter grammar for TypeScript"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-typescript"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
