class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/7e/ce/352fcdba5c72ea20e5d2e46e28809cdb617575b71209d971eff2ace8e6c4/ty-0.0.51.tar.gz"
  sha256 "b90172d46365bb9d51a7011cbb5c60cc4f514f42c86635df6c092b717f85e1ac"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da97e006a1e885700cb31b86ac3bfc9d03d5379e40c2d43c3d1a3eef581a7d42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b696beccf94095ea12a79d5acafad865d0919e7a8f6a81ef89630d32a2c0c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d652bd1c28faf8e08b65ea5c837a2e883af9870067cf20e64cd225a9b87fa49"
    sha256 cellar: :any_skip_relocation, sonoma:        "222d5685fe5a613138797868c287bdd4703469f2346c371dfae10b50431e3e9b"
    sha256 cellar: :any,                 arm64_linux:   "2f66c07cd557ce97af16d4961ed65716a9fad3ea81462fc0ccceaaea70186552"
    sha256 cellar: :any,                 x86_64_linux:  "d14f4aa99e886d0366026daf32c1950b11184540395136ee1a4dbc6a6bd5786c"
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
