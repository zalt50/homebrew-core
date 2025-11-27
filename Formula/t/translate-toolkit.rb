class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/35/7a/a924676cdc005a9a30284b116d6545547524222b2e85381ff4a5df06d544/translate_toolkit-3.17.1.tar.gz"
  sha256 "1a34870fc9a0dd6610b89d3ba93af1f87732f192e40b4978eddac0d15493019e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ca08e228bcc66d72df3768a301ae83c5198e79e2a6273059397577ab1eb0ef8"
    sha256 cellar: :any,                 arm64_sequoia: "420bd472f3cde3c56552224dfcc4f12efa3f8028e0601d5f69008d92f9b28cf2"
    sha256 cellar: :any,                 arm64_sonoma:  "003b991ef48e76f7b8ffed0cd8c3074258ea379e074be4130971f4955a02bb05"
    sha256 cellar: :any,                 sonoma:        "eabdc8abb7bba17518e55b9ec2686aac84a0741dbbadabc7523ddd2843b38f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d23db5d8118e080ccb8a0e4627f3f4640e5c2d52b2607ed71e3c7b00f4d7c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd49b114bb242d75da76bcc9f4582fd87ec04924aac3267dab79e06fed881918"
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
