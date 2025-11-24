class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/01/80/9e0dad9c69a7cfd4b5aaede8c6225d762bab7247a2a6b7651e1995522001/pyinstaller-6.17.0.tar.gz"
  sha256 "be372bd911392b88277e510940ac32a5c2a6ce4b8d00a311c78fa443f4f27313"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc10b01609a928c23f3b44059c7084c8ae2206e49514c4219d6a9500698cb0db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "473e6c10eb021090c32fd031dce1473e9a0847523c2eb5c6a2cb7ff08a3000c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8b1b597fcb354e4ffce092b91457adaff8a6775c52852b87dbf6639e7a4247c"
    sha256 cellar: :any_skip_relocation, sonoma:        "68894b05bf5b8ca0934d8300d3ed75f0fc93e5de0be425caf048d117faa16f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1010bf24a461d198a984f668a6d4a5a663c5f5538130ec22edb336f6c87e21df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87db990b0f53f2b143d829272b420dc6c462c20d6451b495ecd443358a9567bf"
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/26/4f/e33132acdb8f732978e577b8a0130a412cbfe7a3414605e3fd380a975522/pyinstaller_hooks_contrib-2025.10.tar.gz"
    sha256 "a1a737e5c0dccf1cf6f19a25e2efd109b9fec9ddd625f97f553dac16ee884881"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_path_exists testpath/"dist/easy_install"
  end
end
