class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/bb/cd/aee86c0da3240960d6b7e807f3a41c89bae741495d81ca303200b0103dc9/ty-0.0.3.tar.gz"
  sha256 "831259e22d3855436701472d4c0da200cd45041bc677eae79415d684f541de8a"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf887ecf4e724148f81b82f23c1dfc95d0bc3c01d7a89b710c7aec4acacf9d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c15de02a942269eae6c505721383d2fad09b41726a1c56379ecaf64f00568860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58cd3fdeff168a67da4847b5036f6262646499100b1ff8b640a1387716491f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "49c8da4aa09ae5c51e8dbaaba171bf4b7a28b2c076e57c8a8fbda977559366f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe1864fbb1a9268cf51472a6d6a0d3ea924bdb3d853774bf0ae04b68ab94439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db8b1444d7f5538e89abc16c18b638d144e9490fb385ec4db1198440ab8ca09"
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
