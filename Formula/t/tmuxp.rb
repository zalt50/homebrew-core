class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/bd/23/07b83d7842883c5a8dbfa9de28ea1e4e409555461844bbc6001f040650d3/tmuxp-1.69.0.tar.gz"
  sha256 "e0e81428cf29cd9ddec9ac1197d73a00bd0486daf6d2b8911c1fb98e001da5d2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63894bc0ed8ee3890c5331de5efffee3c8a1d08f755244570b7af868d25711e9"
    sha256 cellar: :any,                 arm64_sequoia: "aeaf78300d6ebb58c662259608c41330465827e98d9570f7d3de039d15872062"
    sha256 cellar: :any,                 arm64_sonoma:  "87c2194d4daf616227c80393f2c661cc578706939b69192799e11e42bd6c3dfc"
    sha256 cellar: :any,                 sonoma:        "b2ab2294e2338c5911c4222b08948edef07c843ce15ba54a7aa91019a826da1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b04edddb3f7288dd95ce761d1b1119fdf070d4d76915e11d09a8e42de309a729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7cddddd5e67114c99c199ec261c46ff3d4d28d8dd77a215358db4bf6f1c53c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/da/42/790280a61c8c49a15b3213614f52d0a4f79ec913e9520d35096b1bcb28f2/libtmux-0.57.1.tar.gz"
    sha256 "c216671a066d06e093d7a8e806d0b7467e5f7edfe08742686de33073e1f9cf2a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end
