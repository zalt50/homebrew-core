class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/f9/f467d2fbf02a37af5d779eb21c59c7d5c9ce8c48f620d590d361f5220208/ty-0.0.1a34.tar.gz"
  sha256 "659e409cc3b5c9fb99a453d256402a4e3bd95b1dbcc477b55c039697c807ab79"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fbdf628ec1e95fe88574b219140bcbd0c3db2ee2410e0ebe29300f75a548d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92fba572465bf73de24812dbc82e5a1364b8c5549f7465dac4de9714116f5543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8cb91798566953027b0c1dc746c30fc1a83c6b4fb04f974cd99f2bf447ff05c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1c89a134c58c01a79a1f1854c792c716ffacfe5cfe609f34cb0d38d1786221a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c7dd16676226d20dab918271e18dfcae30170f34d77ff122a8b8d9d4b18aea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aaf78004d766af58cdde99ddb7789d10c1d0ab70783b2b1c59d6de841ad53b8"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
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
