class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.17.tar.gz"
  sha256 "87aa018059e94debf8a6bf27117f36570e89d412a467d2bc6a31fecb374110f5"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55c587df317149640d9bdc4fb0055793b08322f9779393e75c74c508d44d7cc7"
    sha256 cellar: :any,                 arm64_sequoia: "33d15e966a3e7f6b5766d08bfd9fa0f2cbf9931043c02210e74392ff3eeafa4f"
    sha256 cellar: :any,                 arm64_sonoma:  "5ea7ef502a4685ae9e6b85c107bbe929a43e44563faec707a65ac6b40f60ee2f"
    sha256 cellar: :any,                 sonoma:        "d97ca1db2078044db1810ed31e71d1b79cfc09f11bc53163efd085b27e9b4e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "985a0a05022c9ad40764e748848f9044e031cc25624c09d9372693879e8269ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a521ae8f8a0fd779ad5160fd11e02071223c86ed1278e2e82cac172e21c69ee9"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/3e/7c/cb4a5fb0d3d0f6585894759730ae9052e8dd9d2e5172bff544d369b24243/dulwich-0.24.10.tar.gz"
    sha256 "30e028979b6fa7220c913da9c786026611c10746c06496149742602b36a11f6b"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/0e/15/2e1521cdc326919afa9dceec17e318abe325cab893512fd571c58819835b/fastbencode-0.3.7.tar.gz"
    sha256 "e96fd955d6d5980a913730ecbf838ca2863a6420f0d7c8d189087caa83393f21"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/12/71/daaa7978561b9a7bfdcee4ba5ec2ead6162f6a9d2e2edf069def96085c6b/merge3-0.0.16.tar.gz"
    sha256 "0852de4381cb46be5ef4ed49e3ac20c5a4a0cd46a8ff4bbb870bc27aab543306"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/29/42/795991d063200c34094686bd3659a228caa1f4aca1afa98593d06a3d9344/patiencediff-0.2.18.tar.gz"
    sha256 "a678d8252bfb060f1f280fd32d47d917d323e93e1a94ff4ddaaba693a6f66aad"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin/"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system bin/"brz", "init-repo", "sample"
    system bin/"brz", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin/"brz", "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end
  end
end
