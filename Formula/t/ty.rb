class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/5a/f8/a754c96967b71de8723f88be17df8738216bd382ffed229cd500b7a24d13/ty-0.0.40.tar.gz"
  sha256 "883b53dd98f6e5b33ab1c8e1a3cd94b0f29c762ef22cdf1e86aaffb4fd711c67"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d47612a1b2b590cfabaffc68c7e27dd1befe56e27ffd6eb4c9cdc1724d9660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e0c5996eeb86d5bdc3233d69d96a1353701ae6fe90b57d8c4e143f2707342a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2db2524e764795bdecf5dc75879b159edefe20e384c9c35a0618c5e43d8619da"
    sha256 cellar: :any_skip_relocation, sonoma:        "57935d906f1b4d7cc4899b4d3f0722da69f0f18b902b0cc782b0c096f7cb08a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92933070fc7fc779263884eb916de1f0a4a093f60e25fabdcc542f49c6d3f688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9f0645fa7cb43ace1c3765dc35bb3a2fa393615a2b6a2544e1e89f68c9a6a0"
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
