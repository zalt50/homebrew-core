class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/35/7a/a924676cdc005a9a30284b116d6545547524222b2e85381ff4a5df06d544/translate_toolkit-3.17.1.tar.gz"
  sha256 "1a34870fc9a0dd6610b89d3ba93af1f87732f192e40b4978eddac0d15493019e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "831d30dccb3ef848395098312d245a3fa35e6ac0e88ac49c52ec10922c610667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ff5f8c4d344902487841221164ec2c81f9cdaa93182f9369b851fa91b39abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9ed2e6cd0eaab3892af4e0cbea19f3870509598274c6ab3e472ac3d0c5baee"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1929c15199c07d3bc0a28ed206a65181d12319b071304dba779d52bd3f6b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd4143c1f3fd820524b8fbee54c75fc6c222429ea17242f4f60ac2ae1280263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecec91a191856d1061249bf15ebcc38a625a9c395c016e72d4c07200a5cb20c"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "unicode-segmentation-py" do
    url "https://files.pythonhosted.org/packages/25/29/0d55d00861190194f6c9ecf75c986b8a7cf76fbf088c466119c282af88a5/unicode_segmentation_py-0.1.1.tar.gz"
    sha256 "b9de0860441e8f3c2143ab814435cb43198c0aaf8870988a3156e4f84a6c06df"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
