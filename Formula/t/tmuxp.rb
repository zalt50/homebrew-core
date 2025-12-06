class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/a1/a8/b042d35f9f010633020b54da990b586f36b85161590043c6770b549c7fad/tmuxp-1.60.0.tar.gz"
  sha256 "b70d05f561eac9f970cc31b5f55a9f45728ffabf611f3e15111af9a49427c445"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04c302673f8b7643c2a08406f65f279ba889eb81539b21f87cd067cd52459a28"
    sha256 cellar: :any,                 arm64_sequoia: "c5668443a647c88ed05ba72ff37e3150b92caa4b662bcc830790809ff3b5a3f0"
    sha256 cellar: :any,                 arm64_sonoma:  "760b74878eec092d8f9e4bcde896011f212b641d7be6d6f77b63144c25703dda"
    sha256 cellar: :any,                 sonoma:        "9d27584fb013d3d77d3e04638812d7a721477678c01b11f94887db1a3f6cb600"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9868b3c647e8c3de8c19b4c4ea5b2d462c103c2e07237b97439b8045d72ec4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2023078c9a9c2add5295405e20ae39f92fdf4c0d28cc674bffd34c40294e0c1"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/fc/fd/dfc5fff48128a4790fd69a55d10024f4a322e4a6ef4564c221dfa71df4cf/libtmux-0.51.0.tar.gz"
    sha256 "4f75bb8692163374adbdba451a4959834b542c2b749892d9139624d478fc1771"
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
