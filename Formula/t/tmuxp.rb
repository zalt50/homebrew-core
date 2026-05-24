class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/85/52/73b067221b0c790b7dc4da77f7f74d6171c9473c71f558ae67f69966cb1a/tmuxp-1.70.0.tar.gz"
  sha256 "5da9c838e9598cde4ae214f277f9f4985a2d07b180ade421a7a52299d429f95c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25c72551f83776042a48b7806fd833456b3395e573be8a28b8451b0ea5db33ce"
    sha256 cellar: :any,                 arm64_sequoia: "b524d037e86cc8928162d14dd0e7856c5c245848061ab4385215a0e98d6d0b03"
    sha256 cellar: :any,                 arm64_sonoma:  "f084eab1d6198d706e5fe6b7adc63203fe9f8586d1e7fcf0848fb17aa91887a3"
    sha256 cellar: :any,                 sonoma:        "f00e07d3ea818ea99889da947353028813db17b2df387e9cd3a6a4d0b9e5b654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6abbe40e75e719f03a217ad5cb8ba5dc821e90793319d4756f18980df0eca0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c388f7c7d93870c25d2502a0310db85012af176121a79131314c16c0ce62b0a0"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/65/4e/daccd4fd72ad3f17b8fb97f69403774d6c510b5d513521b454fdaedb0561/libtmux-0.58.0.tar.gz"
    sha256 "abbe330bec2c45687a4bf417ee436373b37046afe123ba547495ee0448e1145a"
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
