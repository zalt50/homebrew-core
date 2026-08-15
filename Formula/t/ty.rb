class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d5/df/656e684bafb13c1d146e7d5b5f3e7978ca177232acc84998ff36427e9462/ty-0.0.72.tar.gz"
  sha256 "ec2b8066b618df18cab4cb8e992f8da45d360332acb23fa34df7fa29cd1b9d3a"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9c4f09d422dd8e0e8d78eff50a105bf70b8e69bac0cc3ac99977113e1afa91f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0efe63f88f5cea397a25900cd7208e923b320f03423e7828cde10e895a2f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1527cb3b3030077b5b354e74d28e5743ef36bcb83f568d912bb62685b9c0a24"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0f4f7c6e0ecf99766765ee4f3b14de7e318ae398d06edbad0111e720e62a15b"
    sha256 cellar: :any,                 arm64_linux:   "f0f9de3aaa3ce6e5ca21d4a11ad015938ff95658028ad5857487fe9c5b806600"
    sha256 cellar: :any,                 x86_64_linux:  "1ec7e2c4cd1d84618d5d6afaa96bb54eb12e7de621167f03962a5e7a0a31c449"
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
