class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "afcc2066b1a20fbe003251d2e45b8b2cea740ef689a92390848508b353998461"
    sha256 cellar: :any,                 arm64_sequoia: "ef4e272237c57fc919e84a83ec656a2573fc2c2e9abcb1f8ee38337674c4547d"
    sha256 cellar: :any,                 arm64_sonoma:  "01a862f7035899d724bbeed466ad5ab40ade22df6a1ff1bd6c925c2771d27a52"
    sha256 cellar: :any,                 arm64_ventura: "339a027a25e48fb1e5c1a5cdb0315413d2a22852d01fce952590cfaac67bc1ed"
    sha256 cellar: :any,                 sonoma:        "8b80fe566da1c2fadee35bee233b56184e4a48e7c21faeda2a564d2d8112ffe8"
    sha256 cellar: :any,                 ventura:       "12e0ea9ebce34b1860ad367c9e22e0939307015a31e7dc3ea35b49476fd14d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d26f20621c5873d0dba005a698850a57371ad314eeda2648546021c32ba6787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0a7931adf9d985ed1cb030375174607fc4fd2b676d3e28dbc193558bde2f9c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/8d/37/02347f6d6d8279247a5837082ebc26fc0d5aaeaf75aa013fcbb433c777ab/markdown-3.9.tar.gz"
    sha256 "d2900fe1782bd33bdbbd56859defef70c2e78fc46668f8eb9df3128138f2cb6a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Header 1
      ## Header 2
      ### Header 3
    MARKDOWN
    system bin/"mdv", "#{testpath}/test.md"
  end
end
