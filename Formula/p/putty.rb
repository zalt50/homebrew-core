class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://putty.software/"
  url "https://the.earth.li/~sgtatham/putty/0.85/putty-0.85.tar.gz"
  sha256 "13fd4db2936d03b73812a7bcc2a658e4dd29cc776a56c3670a7fc6f1a0ee8af8"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f2b413c1f4d4f3bb5914b87ed9c56a3e3fe70e9586cbc95439b13d5d64d817dd"
    sha256 cellar: :any, arm64_sequoia: "c70bdac7c9056285ce2f9f72d267f08e65d0882194075e07d89f8e2ca27c7fde"
    sha256 cellar: :any, arm64_linux:   "2686ef42881e45a49a850c0f6c19b94d191462e1484edc25f895e0a769bd808e"
    sha256 cellar: :any, x86_64_linux:  "298323eecee897dd5d56a0ed5653742e572987dc2cb2cc742a40d5301f2047f9"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxrender"
  end

  conflicts_with "plink1", because: "both install a `plink` binary"
  conflicts_with "pssh", because: "both install `pscp` binaries"

  def install
    args = ["-DPUTTY_GTK_VERSION=3"]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # to reduce overlinking

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "expect"
    require "pty"

    PTY.spawn(bin/"puttygen", "-t", "rsa", "-b", "4096", "-q", "-o", "test.key") do |r, w, _pid|
      r.expect "Enter passphrase to save key: "
      w.write "Homebrew\n"
      r.expect "Re-enter passphrase to verify: "
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_path_exists testpath/"test.key"
  end
end
