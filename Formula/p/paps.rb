class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "603bab59a49a8dd76b2a025919a705d21d44c8e929c72c6ed5e7ad0e87fbc486"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c62494b8dadb713c19b4ce12625946844f1b34406317643abc84572476ab9c31"
    sha256 cellar: :any, arm64_tahoe:       "8d95f99591217a56718331ee68a6996b39f059ca4aecfe5d0921a11566d75735"
    sha256 cellar: :any, arm64_sequoia:     "b26fed1929f8d01dac18fb575c540f386006b2db8ce860288001f1424b3e6baa"
    sha256 cellar: :any, arm64_sonoma:      "e3679db03c165c79cdbb9a8ceac9fc0df4f3226622590452249e076e38ebe0ff"
    sha256 cellar: :any, sonoma:            "183b02cb1d125fa77ad0320bd003589aa346d9077d530ab85779916c41503547"
    sha256               arm64_linux:       "f8bff76dd84fc102e71509567f16a62036320efb8d3fb10240cee22ae5b70d19"
    sha256               x86_64_linux:      "cf456bd3c1d9da480517bda9f2bf04ca1545c409538e802caba1c11411329029"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "glib"
  depends_on "libpaper"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_path_exists testpath/"paps.ps"
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
