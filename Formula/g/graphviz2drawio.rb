class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/fb/e9/2ba4114579f8e708b6b5d671afe355c9b8cdd52b15a9d126ec188a2bcad6/graphviz2drawio-1.1.0.tar.gz"
  sha256 "8758b9eefbac5d8c03a0358c0158845235c9c3caa99887f0f6026cfecc2895f2"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "066b2249697049321616006afa5a0f0014f0af66993d7e3a85abffe94ab85b30"
    sha256 cellar: :any,                 arm64_sequoia: "2fe8dcf491fc333babb0bc4b24aa6485b1d60245aa0b61d7aa65013be4bc813a"
    sha256 cellar: :any,                 arm64_sonoma:  "567390b769236d110cd932fa10f800a10bd8427c2ee1119d8eb039ee0c013ff6"
    sha256 cellar: :any,                 sonoma:        "82948bb320565aadc91e341512aee3d985eecdc305d413180751249bee2b414e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6aa1274f8e7fe34480578015201845f5bd4b963c3544063dc28d1e9a33c549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b271a3046503c0c35311eeeef62da8bf193834407842c44880628a7abce506"
  end

  depends_on "graphviz"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/66/b9/649abbe870842c185b12920e937e9b95d4c2b18de50af98d2c140df3e179/svg_path-7.0.tar.gz"
    sha256 "9037486957cb1dcf4375ef42206499a47c111b8ffcbac6e3e55f9d079d875bb0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
