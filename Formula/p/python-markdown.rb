class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/7d/ab/7dd27d9d863b3376fcf23a5a13cb5d024aed1db46f963f1b5735ae43b3be/markdown-3.10.tar.gz"
  sha256 "37062d4f2aa4b2b6b32aefb80faa300f82cc790cb949a35b8caede34f2b68c0e"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "43daa06408e2aad27172be846736935c73710e453ddcc781d29b68fc0b235d9a"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output("#{bin}/markdown_py test.md").strip
  end
end
