class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a3/20/e1e92c8f05666debb7c0c18285646195ef9915e72127771962408609815e/chardet-7.0.0.tar.gz"
  sha256 "5272ea14c48cb5f38e87e698c641a7ea2a8b1db6c42ea729527fbe8bd621f39c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f7e236d1bffd5995b90d4d5d2b12cfe1f83959d62dafbf332f918abcfcbe595"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence", output
  end
end
