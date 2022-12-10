# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for loki"
ACCT_USER_ID=650
ACCT_USER_GROUPS=( loki )
ACCT_USER_HOME=/var/lib/loki

acct-user_add_deps
