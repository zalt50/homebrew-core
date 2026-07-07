class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/04/ff/3dcc01dab91e5d472183dd8d1ac0368b44b70aa3e678a3e47149e8ef716a/virtualenv-21.5.2.tar.gz"
  sha256 "465da6db2a5b615258cddefb749ceeb3627e4fddda93be88c97ba8321ca3c6d1"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7e717b2af5cb1b6430a84ca2fe57ba15a7e43ae2b1b8d9631218dbf3e39add7"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e3/ee/29c668c50888588c432a702f7c2e8ee8a0c9e5286028d91f170308d6b2e9/filelock-3.29.5.tar.gz"
    sha256 "6e6034c57a00a020e767f2614a5539863f056de7e7991d6d1473aef7ff73f156"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/66/26/8b004cc36f430345136f6f00fa1aa9ed596c8ed1e8504625fa79522ff39c/python_discovery-1.4.3.tar.gz"
    sha256 "ad57d7045a862460d4a235986c33f13ed707d3aeb9153fa47eb7dfd0d4673289"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
