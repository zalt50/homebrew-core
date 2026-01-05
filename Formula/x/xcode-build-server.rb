class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https://github.com/SolaWing/xcode-build-server"
  url "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "92c4bb848af5c8128d4600a93f45e49b89ed953d885c60092459303a5d80e312"
  license "MIT"
  head "https://github.com/SolaWing/xcode-build-server.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ac127101dc6e3887a1d9baebf97452cf19b129c4ab75667c16719484fd38a37"
  end

  depends_on "gzip"
  depends_on :macos

  uses_from_macos "python"

  def install
    libexec.install Dir["*"]

    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"xcode-build-server"
    bin.install_symlink libexec/"xcode-build-server"
  end

  test do
    system bin/"xcode-build-server", "--help"
  end
end
