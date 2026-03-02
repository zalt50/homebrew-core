class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/4f/ae/a34e7a9b2b66bbf6b7dbc64ba5c926ff5003de5a85518ea8417c798d1e52/lizard-1.21.1.tar.gz"
  sha256 "6217f65c4bc724262735e387340477e2931a19a685e95ea217619f76429c20e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c343e4061223be1607f22a812bd608ece6c7f00453e5ed1633713a3e0acbfa7"
  end

  depends_on "python@3.14"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~SWIFT
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }
    SWIFT

    assert_match "1 file analyzed.", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
