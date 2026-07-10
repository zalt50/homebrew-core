class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/ac/5e/c83be8d5beed742079976c2b2bd75f3505166e0ef5aa2ffe67cbced0a94a/graphviz2drawio-1.2.0.tar.gz"
  sha256 "75a4775dd975c932ff7e2bfa49cc5ec6c8f1dffe77a3b5b56d40ae3850af692b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "954e1640d40392d3125956c08981e7899624b6e24b114bfc704b8fc4a5e0191a"
    sha256 cellar: :any,                 arm64_sequoia: "499ba9aeb4254b8717dfbbb9fd64517cba80755f448e013e18311d55b636f683"
    sha256 cellar: :any,                 arm64_sonoma:  "bf32769540b693e9d425c30c065b88b30d3e1169d18c6270a7fd17e1ba6169d0"
    sha256 cellar: :any,                 sonoma:        "50ffcd094a34c8ed5b05038c3bc068f0b14c01e7d2c82e28fc7f48bacf04bf9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8bbabc5e86b17bf857aaa590244513757a9888a65da4186a29e7b00d74b4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680c4fc4b3f8c9ee6fa2fcb74236d86a4bff8d69098bd68fa34d41c7bf9c5704"
  end

  depends_on "rust" => :build
  depends_on "graphviz"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/4f/03/14ba7e94e2a9107324b5435052a34c92df2637274343c26aa44361626b01/pygraphviz-2.0.tar.gz"
    sha256 "7cc6cfff4bfa6c1bf389cbbf72f5995a717c69de69c18763544c04b41181f59e"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/33/a0/4983cdedf62c3a1dd42b698813312fc51dd159983333fce9ec4189cd83a9/svg.path-6.3.tar.gz"
    sha256 "e937740a316a7fec86acd217ab6226e112f51328078524126bb7ea9dbe7b1ade"
  end

  def install
    # Work around pygraphviz source-build discovery and runtime paths for nonstandard prefixes.
    # https://github.com/pygraphviz/pygraphviz/issues/630
    if OS.linux?
      graphviz_prefix = formula_opt_prefix("graphviz")
      ENV["GRAPHVIZ_PREFIX"] = graphviz_prefix
      ENV.append "LDFLAGS", "-Wl,-rpath,#{graphviz_prefix}/lib/graphviz"
    end
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
