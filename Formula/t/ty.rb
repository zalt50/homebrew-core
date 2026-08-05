class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/cd/58/4f6ab2a86589e422a3cf840bcf6114c565e4c39ddf4d0b7cd328af5b52b4/ty-0.0.66.tar.gz"
  sha256 "24bddd4479ce445b51ac015410dd2d34af1cadd62a77f5b3cb269149ed83f9b5"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b20ce5caea4687f147e810fb244784974f361e3f63c5dd2a6164e3c3979a28f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700087383cfc906cdef8eff6ac435e089d67b45b9c991e2660796cbfef66c6e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44d6f1c4556f6863c8bfdb91440c986af181204b2c9ed728787f3d277c42dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d019c2c4a3b169d205c07b0d981b0b4885640ee70d768166b77214f0bb3d5016"
    sha256 cellar: :any,                 arm64_linux:   "493ddb1bfd71490708c2cbcc618d96cdd6f0837b0709ba94daeafedf16e171c0"
    sha256 cellar: :any,                 x86_64_linux:  "5a7d0f1e92927c43b3aea1e99d0d48746be9c3792318ee6a26a3e6b4a0890abe"
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
