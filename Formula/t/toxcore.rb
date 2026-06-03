class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.23/c-toxcore-v0.2.23.tar.xz"
  sha256 "a6c3d559ac06eb6b9d48b3edc72f64a97df823c9f64f7dd97c3999ffdc05381b"
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbbb31e412bfd8ce19e4bed4468c763c4a30553df87af6daaca7890b60863fc8"
    sha256 cellar: :any,                 arm64_sequoia: "22e925fce4d035689ba871e1f04ea5254f2239b7ba660e23a21decb7d172c575"
    sha256 cellar: :any,                 arm64_sonoma:  "590fe74f3e30221b3eef2f02e322da73d547531635ee9749a5c69dac41fd8b08"
    sha256 cellar: :any,                 sonoma:        "02d2a7718ed5dc375c0b69c5a4406ab3bb48465f3f1e447dfa821af05d72c044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "310a1c7117ef774e06419060a7e836f80927052bbf1022831dccaf264ace5e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb493b9bb0c9aeea6a33d9450f6497d4e27c9d4e06b3b2621a033269c09e78c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libconfig"
  depends_on "libsodium"
  depends_on "libvpx"
  depends_on "opus"

  def install
    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tox/tox.h>
      int main() {
        TOX_ERR_NEW err_new;
        Tox *tox = tox_new(NULL, &err_new);
        if (err_new != TOX_ERR_NEW_OK) {
          return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/toxcore", "-L#{lib}", "-ltoxcore"
    system "./test"
  end
end
