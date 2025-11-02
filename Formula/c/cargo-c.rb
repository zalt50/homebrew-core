class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.17.tar.gz"
  sha256 "a92b752f35e3ef54c992b2ba382466eb58a11020d13e62a25a4101bc055d5146"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "537492292c7209f54b2d1244e1e47f29e7406719ae433c0d45428fb6907ab055"
    sha256 cellar: :any,                 arm64_sequoia: "d4c0e1f823f8e0edd4ea763d9c1e8891853b62681d320aa35d7ac8c60be1822e"
    sha256 cellar: :any,                 arm64_sonoma:  "33a873299b6e22e7cd228a7638f00a77d1c009885ee0d36cdab3a09e96e954ba"
    sha256 cellar: :any,                 sonoma:        "2acfb4e4daadc471d01d08ca95f3a3ad51094ebf9904bb4da22d66cc29c8788b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51fb394fac12318c7c2fcacaa816e7125d88c300e4ab2678227af5f2e636ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff866832e4764258837c110650418204defb3c800effcbbd2d3eedfdf0c2bb40"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
