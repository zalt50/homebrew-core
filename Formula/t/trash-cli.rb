class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/96/7c/906fcf701057e67ea9f335d502bfdde2cf353eb149b67fdbc8be4ccd4683/trash_cli-0.26.9.14.tar.gz"
  sha256 "dfff726023223a864181e23ab5e349abb6a8e85d5341c0a4abb1c9340ad8764e"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "143b02428d610f1910b2742ae2387e1535faa44e90c3f41e40d560e059570043"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "096c7187b9376eb817001e3ed11ea683e43d81c25c493c9f1036dc3bea281823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5cefc22f1ecb8432383170c378630a1b2ab97fbdcd63006cddf43eedd70b41f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ce16cef08f1698139e1e509ff3c42621cdad38fe96634593c0ecc7a10458d218"
    sha256 cellar: :any_skip_relocation, sonoma:            "a0cc43661442da45b0e393fc69c9a92adf86dec427dcea7b64bc39bfee6ded85"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f6ad80444c0db11ae7faf5bfa3e119eb09603242938e35ef89fe3e3b080a09d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88aba05ddc72fd1c30e4aa6e69351cd59e4aaf11d043d2eeafa013f0c574c9ba"
  end

  keg_only :shadowed_by_macos

  depends_on "python@3.14"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_path_exists testpath/"testfile"
    system bin/"trash-put", "testfile"
    refute_path_exists testpath/"testfile"
  end
end
