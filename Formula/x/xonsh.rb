class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/45/99/11a67574eb44879de34f162c2e95889134c249c0410cf2823c64b737b712/xonsh-0.21.0.tar.gz"
  sha256 "8679c57e4f5b9ff29082422a1a037da190267e68b4842607591e09d184cfe349"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b41acf34e8e8161831afb17a8c481051c15ddc74b3746b132d035f798ea192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd5a672afe1c2098cb3841644cb07768f911712521132a5ebb4ad39b0b8ecb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d4e1029d779647054f2fd2343f67804e790f0085fc473328e4dc545a25fc03"
    sha256 cellar: :any_skip_relocation, sonoma:        "e87c4eb2fbf765377bbe761c245e46b8e747169de3208cff6cb7e2a4fd065d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1038e3abbbe5f3eb0c585648bfc7955f1aa345efa0e6cebcd288089406ecd135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff0f2d07c74191ea71489797d0fe8a4130e73bef98fe8c08e1eccd3afb9f3a5"
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
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
