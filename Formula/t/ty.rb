class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/b3/43/8be3ec2e2ce6119cff9ee3a207fae0cb4f2b4f8ed6534175130a32be24a7/ty-0.0.7.tar.gz"
  sha256 "90e53b20b86c418ee41a8385f17da44cc7f916f96f9eee87593423ce8292ca72"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3042e287b802571abb0c48f89667b0de97a3306fcace0175dfd737ede9d93163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee9972193a742ac8047d91b34135b30e1723765b184d200a7767166a77642716"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b27542aba23f91367371c989a4709602cc43cbe528902d938f0a4c654af984c"
    sha256 cellar: :any_skip_relocation, sonoma:        "24f484bf3f8248abb8ea78c8b35610c9c7670944e595ca4e2fc47a6cbf51e015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c2d71e10ca7d38e49343ffccaca15f1f25a318e429efd62df222ecf45c0ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c264028b71fb0dcb5b220eff010d9dc67c99df146097caf1c3c2e2751a2d6d4"
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
