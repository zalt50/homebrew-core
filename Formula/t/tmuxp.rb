class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/6e/32/810eeef35be00ef9e0bad1232ed43c39e59e8d57d3b6675494c36ce711e9/tmuxp-1.63.1.tar.gz"
  sha256 "c58a9071c3ea69cdeb3e4fc8b2e37473654b13210aa9dd905790dbff76c1d468"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "746956c04836f5b61c00467f953a3dc7d2d8c7eddfda89fb1da277c85096fab6"
    sha256 cellar: :any,                 arm64_sequoia: "cb0dc82c3c037ade87b32daaafc10e038b7fb2c58aef46e99cbeab42d88980bf"
    sha256 cellar: :any,                 arm64_sonoma:  "1a742033bc8f31d6d750177aeff0e695ddf8089272b90d30d3622f09bb673555"
    sha256 cellar: :any,                 sonoma:        "9960199c283a6af9d2f6bed2a9d9fddfcfe090562e107e62434e6a7397baf72a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131611b9fa808d5b5d3907b401f9c94308323b9e1e40dd5b3a60b4a8f707ea61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4fc967161e53e386ca0702b463014502eae60178beb901d639c16b8aa9e1e3e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e7/28/e2b252817cb181aec2f42fe2d1d7fac5ec9c4d15bfb2b8ea4bd1179e4244/libtmux-0.53.0.tar.gz"
    sha256 "1d19af4cea0c19543954d7e7317c7025c0739b029cccbe3b843212fae238f1bd"
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
