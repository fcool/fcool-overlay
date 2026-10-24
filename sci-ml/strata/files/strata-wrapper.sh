#!/bin/sh
# Gentoo wrapper for the Strata terminal.
#
# Strata looks for its engine only in the per-user component folder and would otherwise download one.
# This wrapper links the engine packages installed by portage into that folder (and drops links to
# packages that were uninstalled since), then hands over to upstream's launcher.
APP_DIR="@APP_DIR@"

components="${STRATA_COMPONENTS_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/strata/components}"
engines="${components}/engine"

if mkdir -p "${engines}" 2>/dev/null; then
	for link in "${engines}"/*; do
		[ -L "${link}" ] || continue
		case $(readlink "${link}") in
			"${APP_DIR}"/*) [ -e "${link}" ] || rm -f "${link}" ;;
		esac
	done
	for pkg in "${APP_DIR}"/components/engine/*/; do
		[ -d "${pkg}" ] || continue
		name=$(basename "${pkg}")
		[ -e "${engines}/${name}" ] || ln -s "${pkg%/}" "${engines}/${name}"
	done
fi

STRATA_PYTHON="${STRATA_PYTHON:-@PYTHON@}"
export STRATA_PYTHON

exec "${APP_DIR}/bin/strata" "$@"
