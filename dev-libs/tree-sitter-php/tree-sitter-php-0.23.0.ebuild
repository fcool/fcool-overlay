# Copyright
EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
TS_BINDINGS=( python )

inherit tree-sitter-grammar

_get_tsg_abi_ver() {
	local parser_c
	for parser_c in "${S}"/php/src/parser.c "${S}"/php_only/src/parser.c; do
		[[ -f ${parser_c} ]] || continue
		sed -n 's/#define LANGUAGE_VERSION //p' "${parser_c}" | sed -n '1p' && return
	done
	die "Unable to extract ABI version for this grammar"
}

DESCRIPTION="Tree-sitter grammar for PHP"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-php"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
