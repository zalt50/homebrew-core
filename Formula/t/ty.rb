class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/f9/f467d2fbf02a37af5d779eb21c59c7d5c9ce8c48f620d590d361f5220208/ty-0.0.1a34.tar.gz"
  sha256 "659e409cc3b5c9fb99a453d256402a4e3bd95b1dbcc477b55c039697c807ab79"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  depends_on "rust" => :build
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
