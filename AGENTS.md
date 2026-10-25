# Notes for agents working on this overlay

This is the personal `fcool` overlay (`/var/db/repos/fcool-overlay`).
Conventions below are the ones this repo follows; please keep it that way.

## Ebuild naming

`<category>/<package>/<PN>-<PV>[-rN].ebuild`

- First ebuild of an upstream release: **no revision suffix**
  (`dabri-2.3.0.ebuild`, not `dabri-2.3.0-r1.ebuild`).
- Add `-rN` only when the *ebuild itself* changes for an upstream version that
  has already been released, e.g. changed build flags, changed dependency
  constraints, or a different vendored payload
  (`dabri-2.2.2.ebuild` → `dabri-2.2.2-r1.ebuild` when the whisper link flags
  were fixed).
- `${PV}` never contains the revision, so `SRC_URI` / vendor tarball names are
  revision-independent.

## Vendored Go dependencies

Go packages here do not rely on the network at build time: the dependencies are
vendored with `go mod vendor` and shipped as a tarball from
`https://digital-competence.de/fcool-overlay/`. The ebuild references it
unconditionally, so the tarball has to exist *before* the package can be built:

```
SRC_URI="https://github.com/AshBuk/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
SRC_URI+=" https://digital-competence.de/fcool-overlay/${PN}-${PV}-vendor.tar.xz"
```

Recipe for a new release:

1. Write the ebuild first, `SRC_URI` already pointing at the not-yet-existing
   vendor tarball.
2. Let portage fetch and unpack the release sources
   (expect the vendor download to fail / be missing at this point):

   ```bash
   ebuild /var/db/repos/fcool-overlay/app-accessibility/dabri/dabri-2.3.0.ebuild prepare
   ```

3. Vendor the dependencies inside the portage work directory, keeping the
   `SRC_DIR` name (`<PN>-<PV>`) as top level directory so that unpacking the
   archive merges the `vendor/` tree into the source tree:

   ```bash
   PN=dabri
   PV=2.3.0
   WD=$PN-$PV
   TARGET=digco010@digital-competence.de:htdocs/fcool-overlay/

   cd /var/tmp/portage/app-accessibility/$WD/work/$WD
   go mod vendor
   cd ..
   tar --create --auto-compress --file $PN-$PV-vendor.tar.xz $WD/vendor
   scp $PN-$PV-vendor.tar.xz $TARGET
   ```

   Node based packages take the same route with `npm ci` and
   `$PN-$PV-node_modules.tar.xz` (top level `$WD/node_modules`).

4. Refresh the package `Manifest`. With `repoman` unavailable, compute the
   `BLAKE2B`/`SHA512` of every `DIST` file and of the ebuild manually:

   ```bash
   printf 'DIST %s %s BLAKE2B %s SHA512 %s\n' \
     "$(basename "$f")" "$(stat -c%s "$f")" \
     "$(b2sum "$f" | cut -d' ' -f1)" "$(sha512sum "$f" | cut -d' ' -f1)"
   ```

   Keep `DIST` and `EBUILD` blocks sorted by filename.
5. Verify the whole flow: `ebuild <pkg>.ebuild prepare` must fetch and verify
   all `DIST` checksums, `ebuild <pkg>.ebuild compile` proves it builds against
   the installed dependency versions.

## Linking against packaged C/C++ dependencies

Go with `CGO_ENABLED=1` needs both the headers and the shared libraries of the
C++ dependency, and the runtime loader has to find them. whisper-cpp
(`app-accessibility/whisper-cpp` in guru) installs into its own directories
`${EPREFIX}/usr/include/whisper.cpp` and
`${EPREFIX}/usr/$(get_libdir)/whisper.cpp`, and the resulting sonames are
versioned (`libwhisper.so.1`, `libggml.so.0`). Point both `-L` and `-Wl,-rpath,`
there; an rpath to a directory that nothing installs into yields a binary that
dies with "error while loading shared libraries".
