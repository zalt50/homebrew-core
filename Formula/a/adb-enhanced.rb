class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/18/3e/8bf74e86f1821d190260e01b7a8efb615ad17f2e247c592df89740141cb5/adb_enhanced-2.8.0.tar.gz"
  sha256 "75c92007bbf295ec97fb89fedf0bd24e6424d726b1343aa3b1fbf5e2115efcc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79e4ba0ad8eff1c52d4f630af4039231824eae00171c113072768f53e7f60482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8deefa2050df50026ff63acc7cd8d3e6addb5bf9ac067b71b830ceac04eff624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646209bc549d1c4fde9b65f8559be8de43251297ebd904449cd4db47a849e353"
    sha256 cellar: :any_skip_relocation, sonoma:        "7038c821594759b71f5333f03752e7178700970629b04d97b0af8f039b4db89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53ece69f192371adbcd68db594082cca95b8a65945e45c5ef242924924a9fcc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a12e4cc653134bef9073855829d87e9931d927325e413b0340a5a3d44ef4d96"
  end

  depends_on "python@3.14"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
