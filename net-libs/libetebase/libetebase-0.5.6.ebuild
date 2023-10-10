# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
        addr2line@0.21.0
        adler@1.0.2
        aligned@0.4.1
        ansi_term@0.12.1
        as-slice@0.2.1
        atty@0.2.14
        autocfg@1.1.0
        backtrace@0.3.69
        base64@0.21.4
        bitflags@1.3.2
        bitflags@2.4.0
        bumpalo@3.14.0
        byteorder@1.4.3
        bytes@1.5.0
        cbindgen@0.14.3
        cc@1.0.83
        cfg-if@1.0.0
        clap@2.34.0
        core-foundation@0.9.3
        core-foundation-sys@0.8.4
        cvt@0.1.2
        ed25519@1.5.3
        encoding_rs@0.8.33
        errno@0.3.3
        errno-dragonfly@0.1.2
        etebase@0.6.0
        fastrand@2.0.1
        fnv@1.0.7
        foreign-types@0.3.2
        foreign-types-shared@0.1.1
        form_urlencoded@1.2.0
        fs_at@0.1.10
        futures-channel@0.3.28
        futures-core@0.3.28
        futures-io@0.3.28
        futures-sink@0.3.28
        futures-task@0.3.28
        futures-util@0.3.28
        gimli@0.28.0
        h2@0.3.21
        hashbrown@0.12.3
        heck@0.3.3
        hermit-abi@0.1.19
        hermit-abi@0.3.3
        http@0.2.9
        http-body@0.4.5
        httparse@1.8.0
        httpdate@1.0.3
        hyper@0.14.27
        hyper-tls@0.5.0
        idna@0.4.0
        indexmap@1.9.3
        ipnet@2.8.0
        itoa@1.0.9
        js-sys@0.3.64
        lazy_static@1.4.0
        libc@0.2.148
        libsodium-sys@0.2.7
        linux-raw-sys@0.4.7
        log@0.4.20
        memchr@2.6.3
        mime@0.3.17
        miniz_oxide@0.7.1
        mio@0.8.8
        native-tls@0.2.11
        nix@0.26.4
        normpath@1.1.1
        num-traits@0.2.16
        num_cpus@1.16.0
        object@0.32.1
        once_cell@1.18.0
        openssl@0.10.57
        openssl-macros@0.1.1
        openssl-probe@0.1.5
        openssl-sys@0.9.93
        paste@1.0.14
        percent-encoding@2.3.0
        pin-project-lite@0.2.13
        pin-utils@0.1.0
        pkg-config@0.3.27
        proc-macro2@1.0.67
        quote@1.0.33
        redox_syscall@0.3.5
        remove_dir_all@0.8.2
        reqwest@0.11.20
        rmp@0.8.12
        rmp-serde@1.1.2
        rustc-demangle@0.1.23
        rustix@0.38.14
        ryu@1.0.15
        same-file@1.0.6
        schannel@0.1.22
        security-framework@2.9.2
        security-framework-sys@2.9.1
        serde@1.0.188
        serde_bytes@0.11.12
        serde_derive@1.0.188
        serde_json@1.0.107
        serde_repr@0.1.16
        serde_urlencoded@0.7.1
        signature@1.6.4
        slab@0.4.9
        socket2@0.4.9
        socket2@0.5.4
        sodiumoxide@0.2.7
        stable_deref_trait@1.2.0
        strsim@0.8.0
        syn@1.0.109
        syn@2.0.37
        tempfile@3.8.0
        textwrap@0.11.0
        tinyvec@1.6.0
        tinyvec_macros@0.1.1
        tokio@1.32.0
        tokio-native-tls@0.3.1
        tokio-util@0.7.9
        toml@0.5.11
        tower-service@0.3.2
        tracing@0.1.37
        tracing-core@0.1.31
        try-lock@0.2.4
        unicode-bidi@0.3.13
        unicode-ident@1.0.12
        unicode-normalization@0.1.22
        unicode-segmentation@1.10.1
        unicode-width@0.1.11
        url@2.4.1
        vcpkg@0.2.15
        vec_map@0.8.2
        walkdir@2.4.0
        want@0.3.1
        wasi@0.11.0+wasi-snapshot-preview1
        wasm-bindgen@0.2.87
        wasm-bindgen-backend@0.2.87
        wasm-bindgen-futures@0.4.37
        wasm-bindgen-macro@0.2.87
        wasm-bindgen-macro-support@0.2.87
        wasm-bindgen-shared@0.2.87
        web-sys@0.3.64
        winapi@0.3.9
        winapi-i686-pc-windows-gnu@0.4.0
        winapi-util@0.1.6
        winapi-x86_64-pc-windows-gnu@0.4.0
        windows-sys@0.45.0
        windows-sys@0.48.0
        windows-targets@0.42.2
        windows-targets@0.48.5
        windows_aarch64_gnullvm@0.42.2
        windows_aarch64_gnullvm@0.48.5
        windows_aarch64_msvc@0.42.2
        windows_aarch64_msvc@0.48.5
        windows_i686_gnu@0.42.2
        windows_i686_gnu@0.48.5
        windows_i686_msvc@0.42.2
        windows_i686_msvc@0.48.5
        windows_x86_64_gnu@0.42.2
        windows_x86_64_gnu@0.48.5
        windows_x86_64_gnullvm@0.42.2
        windows_x86_64_gnullvm@0.48.5
        windows_x86_64_msvc@0.42.2
        windows_x86_64_msvc@0.48.5
        winreg@0.50.0
"

inherit cargo

DESCRIPTION="C library for etebase"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/etesync/libetebase/"
SRC_URI="https://github.com/etesync/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"
RESTRICT="mirror"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

src_compile () {
        default
        mv target/release/libetebase.so target/release/libetebase.so.0
        ln -s libetebase.so.0 target/release/libetebase.so
}

src_install () {
        insinto /usr/$(get_libdir)/pkgconfig
        doins target/etebase.pc
        insinto /usr/$(get_libdir)/cmake/Etebase
        doins EtebaseConfig.cmake
        insinto /usr/include/etebase
        doins target/etebase.h
        dolib.so target/release/libetebase.so{,.0}
}
