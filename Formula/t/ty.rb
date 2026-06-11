class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/6c/ea/2565229df2be7cc09128a1bb2fa8416b2006378b62bc8a3ddcc001e6d52f/ty-0.0.47.tar.gz"
  sha256 "4db42f7a9b606860c98a25adb73059942016cee43d9f1cac1b63ee06063f4879"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb80c3acec4c46454754ecd415d48ae6acd0ebbb616228d1d0a32fcb187ccb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "913b92c055b2d77a9a255afacec461d7abb012a74ed426af512e40fe43516e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "266a20e361ec3160b958013e9241de5bdf20612579d046769f4b592040c08c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f618fd392700dc96306efe56dca71b4872d0abe161f4c289eaed4301452fda"
    sha256 cellar: :any,                 arm64_linux:   "299d795186829c19d1912f505f7c087cff913111933ec718b3f614ec6ea4f3d8"
    sha256 cellar: :any,                 x86_64_linux:  "58bde4bcd46bbbddb2f6e3bb8a926b77a3e36a7e95c2ecf83a5ebd51d1583340"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
