# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for etebase-server"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( etebase )
ACCT_USER_HOME=/var/lib/etebase-server

acct-user_add_deps
