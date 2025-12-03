class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/dd/d1/14615bfc47e38d848c98e7901576f929042b1144e1dc66a93c477b6569a7/translate_toolkit-3.17.3.tar.gz"
  sha256 "05601dc3027096b3b0de831bb44b602eb923c4483bcc5a19cc82d55785bc8416"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7082ef4ed4b525103eee3a57a66181d08812c4eb0d176941b587151f90fc37bc"
    sha256 cellar: :any,                 arm64_sequoia: "ba166b14d898f5dc5a1f169bea048413a018bd5202712c036eff5f31d65d4d15"
    sha256 cellar: :any,                 arm64_sonoma:  "6965df131567048abb669fcd2eca9190a6f343cf474fb48ada7de9ade9e79d4f"
    sha256 cellar: :any,                 sonoma:        "38fd6eb5d0f7d0ce533f1e03c67806dad784fb46ab930dfcb214189e587474e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "022fb77d50d5d3aa49ec4741676628deef78778619bca3a1ef53b0bb64e43b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd27c7ab3c20c42ca9b1743e9b948459bd35359df6004535093cbb35011e1423"
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
    url "https://files.pythonhosted.org/packages/6e/47/ef80c65deddbbc38ec2806b068430dc5052b906c5cee19cab3013ae631ff/unicode_segmentation_rs-0.2.0.tar.gz"
    sha256 "137246f8ccadf249e4978503a88438de68205d89bf360ddeece340938c33caec"
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
