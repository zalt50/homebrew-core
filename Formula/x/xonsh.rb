class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/73/1f/0e1c1cada568ac7b8fe06f57470d06472538b489aea5326839353eed261d/xonsh-0.22.5.tar.gz"
  sha256 "a8ccd3b0d696b0987e4eae4a5cef81beabac527f369c5cb168ea5b3553795c89"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26f5f3149fa2a6cf95a1b1eaec58ccb4900f6965c717da28ee920339763b8098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a953529d01040b2ea1edd10a0cff8d77a60212e4fea662c5d63cb50b121f2f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2702dbc09ae7ff99a43b0097c4ef2f760086c4dd4e5d8d0924b60027d04db481"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa7fbf110a2ba69ca1ef5b8369687104fa4ccdd4feec078b30d5c97b22c15ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f83c157c5b5532fc7deefd635dac6a2b232ae204fcf5678645d8069accc69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edb63f5225bec04c9b48a0b087f7d6ba1f6b7a80cbcdec6e775111a728ab362"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
