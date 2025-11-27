class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/28/18/83ce284aa0fd118d3e74702f16c2aed0807620954f60d5098c7150b286dd/translate_toolkit-3.17.2.tar.gz"
  sha256 "48e549c43a807959b7696353a8abaee4ce47cc99d4e9e5fb95c581b0b6cf5b38"
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

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/8f/92/b3859fa72a402162e2671bb3f53ab720fee98a28ae1d28ac0dd96fea9ff8/unicode_segmentation_rs-0.1.1.tar.gz"
    sha256 "6bd25cdadbdd1a2fa5a9aff96a9de5bd8aa8c7d31a61a395e3e61a646fb31917"
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
