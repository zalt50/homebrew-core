class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  stable do
    url "https://code.videolan.org/rist/librist/-/archive/v0.2.16/librist-v0.2.16.tar.gz"
    sha256 "ffcf575f02032ec89dfd6effa2e6f9a505d8dc2902853f10e83ab169ea588e20"

    # fix: remove unused mbedtls/entropy_poll.h include
    patch do
      url "https://code.videolan.org/rist/librist/-/commit/df07717cab40fef2fe89c6831179dceb1a659066.patch"
      sha256 "5391be5b07a21dbcf1b6454888f44c6ebc2a0b34cb14c644c6e20f52917f223c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38416f33ef3303bd60dd229a180a1c8960dec27972a5bb8e9d38cd115840e7d6"
    sha256 cellar: :any, arm64_sequoia: "512ab76d8fbe706ba8b2d4779448ea423be44fc344ca257e43585343eff8eae4"
    sha256 cellar: :any, arm64_sonoma:  "9a5c22d5466562111176fabbad4d19adcdea3bf08a5833a20d14f136bbc29e74"
    sha256 cellar: :any, sonoma:        "befc89f2cc8d90f8b9286b5be7f77c032c7d91d93c78cbc38a903074d4a65c18"
    sha256               arm64_linux:   "c330cde0b091b7f4e656026c3211fb3d2b2754cfd6169a89ad6ba111e3deca6b"
    sha256               x86_64_linux:  "b363acd98eb0a20fab942f616de80c5bd330f64278ba4d5dcc7b3f606daffb69"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "mbedtls@3"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
