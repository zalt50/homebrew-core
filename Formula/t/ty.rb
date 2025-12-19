class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/48/d9/97d5808e851f790e58f8a54efb5c7b9f404640baf9e295f424846040b316/ty-0.0.4.tar.gz"
  sha256 "2ea47a0089d74730658ec4e988c8ef476a1e9bd92df3e56709c4003c2895ff3b"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04416653dbe579ae3ee52bb17340e7018560399e59b651c2e565ebc184e00382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07191f1bb477c80308e0e21630a33fc5bf4cbd57ba215c21332cb70ea77b9e12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3938a2722df30f6163162bb5f2b29127e4c50ea15cbf92e1c6f397e65afd295"
    sha256 cellar: :any_skip_relocation, sonoma:        "f889fe143fa05b116e1d340df1768b8f8c3c3773e55b61bc6ab45cf220662eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322a4a61811f7681ffb69cd86afb8799e066c4a1b9ea48632e98e647b87b0062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92cc30c3d3aae67007fde12870e04175780f8b97faa05964ee1880b6d87762a0"
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
