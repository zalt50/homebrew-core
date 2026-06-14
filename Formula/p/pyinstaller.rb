class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/d5/4d/ec706c3fcf39e26888c35b39615ff4d5865d184069666c47492cff1fbe50/pyinstaller-6.21.0.tar.gz"
  sha256 "bb9fab705983e393a2d1cac77d6972513057ad800215fd861dc15ff5272e98fd"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e7bde3effe6d5704f85e126f31b1f97cfdbc77193d49f80c1e349eb440e0c1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf1cc164c94bf9fea352935c87ceea78cbd7741b40dd309055eaac31d6c1a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9098d66121dd0399504f4d1b4c71cee6048cb5bc1c07dbb754c9a77ef1be80f3"
    sha256 cellar: :any_skip_relocation, tahoe:         "74d0bf37ef712691a6ad502ad773c8a9c9926b036c1c91fc0a54d5bb60507561"
    sha256 cellar: :any_skip_relocation, sequoia:       "cc65d81b8970ec9e0e383410266a3a1cfc9d61c6e0060d8f0f8ec8e98b2bacac"
    sha256 cellar: :any_skip_relocation, sonoma:        "68685e7133a973aecfa42ac084ff6e9d0012765c87eb49473416e078f2838f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d77020b961151ac0ed3e8eb32c9634ca1e4065e2c0211326e5c45be0cd7a254f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a70ececf86df4d0430126c3b291368ed3cfd6af4983cfdd5a9b631ff00fcec"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages extra_packages: "macholib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/94/5b/c9fe0db5e83ee1c39b2258fa21d23b15e1a60786b6c5990ee5074ead8bb6/pyinstaller_hooks_contrib-2026.6.tar.gz"
    sha256 "bef5002c32f4f50bd55b005da12cff64eca8783e7eaf86a06a62410164bab725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    without = ["macholib"] unless OS.mac?
    virtualenv_install_with_resources(without:)
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
