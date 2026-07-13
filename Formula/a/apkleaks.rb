class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/1e/e6/203661abe151dbc59096de65d6f0cf392d1aad3acba32f4e9f3f389acad0/apkleaks-2.6.3.tar.gz"
  sha256 "e247b59acf4448f3c2e45449bc7564bc5b7a216ebfb166236baf602d625b1df5"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f306c7278077caa6a4068d501adfb95345fe39bc6add9ceb759f70fb965057b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d390af53ad407f1cf952e8b23d5688850440100a6f944393119c6591ee3638ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "054cd745343049dfb4113ea39e7ec69bbf471d4c3a9a37947351e9ac5403547d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e524812eb29c7b3eec58d93466856bc1583332b46c33c6fb3155068c4a291ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9143ccbd89bb4ba2641dc4127c277aebe4bf55d27e888d4c5af94298d3c0e8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc01ebfa7068a19c809ce7241cbafb88c0e518fdac5274a435e3c8584eb25dde"
  end

  depends_on "jadx"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/1e/1f/7a7318ad054d66253d2b96e2d9038ea920f17c8a9bd687cdcfa16a655bdf/pyaxmlparser-0.3.31.tar.gz"
    sha256 "fecb858ff1fb456466f8dcdcd814207b4c15edb95f67cfe0a38c7d7cd4a28d4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkleaks -f #{testpath}/redex-test.apk")
    assert_match "Decompiling APK...", output
    assert_match "Scanning against 'com.facebook.redex.test.instr'", output

    assert_match version.to_s, shell_output("#{bin}/apkleaks -h 2>&1")
  end
end
