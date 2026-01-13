class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/28/a0/8fc2d68e132cf918f18273fdc8a1b8432b60d75ac12fdae4b0ef5c9d2e8d/yamllint-1.38.0.tar.gz"
  sha256 "09e5f29531daab93366bb061e76019d5e91691ef0a40328f04c927387d1d364d"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b47462e8eab9f22ab1768d1d86018e1df02aa972b8c67163b2b34e4c6959d671"
    sha256 cellar: :any,                 arm64_sequoia: "ea04f0dafe4271e07c7f44863b9a964c87710137cf0fed479e2e3101403a1365"
    sha256 cellar: :any,                 arm64_sonoma:  "9220591106b4eeb94899f1f5c071fa0ac30e609e0b2907b19a60db12d4cdfa0f"
    sha256 cellar: :any,                 sonoma:        "ba48a03d10464d37ca4e116a9e50f4479967b8683b324cf3951817a31f2587df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea18bdce2239ed653fae04f914e43dd3eb5da910f49a32277a62dc3b1652df8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e2093dc7b6b03151e46cb5060eb234bae9e182a35a8742b0bcdd41f3f9f8b4"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/4c/b2/bb8e495d5262bfec41ab5cb18f522f1012933347fb5d9e62452d446baca2/pathspec-1.0.3.tar.gz"
    sha256 "bac5cf97ae2c2876e2d25ebb15078eb04d76e4b98921ee31c6f85ade8b59444d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~YAML
      ---
      foo: bar: gee
    YAML
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    assert_empty shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
