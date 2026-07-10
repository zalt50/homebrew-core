class OnionLocation < Formula
  include Language::Python::Virtualenv

  desc "Discover advertised Onion-Location for given URLs"
  homepage "https://codeberg.org/Freso/python-onion-location"
  url "https://files.pythonhosted.org/packages/72/0d/e2656bdb8c66dc590da40622ca843f0513cd6f4b78bb1f9b6ed4592d283e/onion_location-0.1.0.tar.gz"
  sha256 "37dc14eab3a22b8948f8301542344144682108d1564289482827dc45106ee1d5"
  license "AGPL-3.0-or-later"
  revision 3
  head "https://codeberg.org/Freso/python-onion-location.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5269569ff0fa6d6df925661c2e84af617e587c8c88a143780ab22a5cdb7b05a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc2d10df3c754847b79e6ccfc7487de05882bf0c06ae202a0ca9ca7345d6201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da547be0eefb2d66baaf86ffa2d2104668a2f666e16508617e8db76a1eb88d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "526d7270029ec4d12f3cae562cd87899a187cc44d299e050e64654de247ef1f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f4fbccbe514d2545b48ba333cc11bd29e6fe6413b8e31e03ea2ce66a2416c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa473935477f402322158be862a9cb575c67ed375e7932ecf9877d094a57ceed"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion/index.html",
      shell_output("#{bin}/onion-location https://www.torproject.org/")
  end
end
