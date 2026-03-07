class DirectxHeaders < Formula
  desc "Official DirectX headers available under an open source license"
  homepage "https://devblogs.microsoft.com/directx/"
  url "https://github.com/microsoft/DirectX-Headers/archive/refs/tags/v1.619.1.tar.gz"
  sha256 "6193774904c940eebb9b0c51b816b93dd776cfeb25a951f0f4a58f22387e5008"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a605831ddbce7dc030332a6f37b2acaca0cc200a4ea479f561ee3ec54101b428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81b94674a1e9dd1840dce8419357f7fc1d85767fae59284ded28e2284213f1a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5199836ae830e1ddc3faf87adfc47e73924af9c46696a9580007a4c940f503"
    sha256 cellar: :any_skip_relocation, sonoma:        "c18d3cbd758e2177eb9cf24e15bf4f574c1a34e9f73ec25eec672ff168f789d8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "mingw-w64" => :test

  def install
    system "meson", "setup", "build", "-Dbuild-test=false", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "test.cpp" do
      url "https://raw.githubusercontent.com/microsoft/DirectX-Headers/a7d19030b872967c4224607c454273a2e65a5ed4/test/test.cpp"
      sha256 "6ff077a364a5f0f96b675d21aa8f053711fbef75bfdb193b44cc10b8475e2294"
    end

    resource("test.cpp").stage(testpath)

    ENV.remove_macosxsdk if OS.mac?

    system Formula["mingw-w64"].bin/"x86_64-w64-mingw32-g++", "-I#{include}", "-c", "test.cpp"
  end
end
