class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ef/aa/2188e11a0a1b80f9064f1d10b818ef9db40322ab5b57c5878712ba962b15/tmuxp-1.59.1.tar.gz"
  sha256 "adf5c31e3edb405944ec404dbc3e09fc8d8c43374fe8de9a495119f78bedfe9d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81657391f7748fc9245a3ab33d35aba734092ca5b528c5f8e4bc1670a75720ec"
    sha256 cellar: :any,                 arm64_sequoia: "ab174cb670441ea9e1fbef811b36124848358f9a4f44401476be04ce9494fcad"
    sha256 cellar: :any,                 arm64_sonoma:  "d7595424e36c8ddd450c3ad4c20a1a40d2ed7963f96a0a3fbd30b4042c25de66"
    sha256 cellar: :any,                 sonoma:        "3b3d978694bb8301f1f19cf9ade4c8e33e46dadc66f6bfbf27bafa1bdd56d2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c8cd41b1108bbdb645f7141ba2ad5995c321fc1c4b959d1a6f28b1a269780a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b3f71325a2a068100822414bfd64164a55b14312de3e686f8e679466756ef9"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/36/b8/36bc4442115c4024294373976538a8f72394557162ede3d31d529501915c/libtmux-0.50.1.tar.gz"
    sha256 "69ca77851313da2eff62519ba804b872d5b8391424a5bc4b90c605edfae94b4f"
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
