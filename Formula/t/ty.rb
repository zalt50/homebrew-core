class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d8/91/5b5ec4ed8721c18be8d9611778d7c07723cd755676f03b41bf0ea0caa5d3/ty-0.0.42.tar.gz"
  sha256 "70f5553ac678fc63558d4d77b08a18a68a228f44be2a2fe1afc3f5988db662e7"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "376c81ed771f07d88a2c32a3927751047dafd16dbcd8fc4469f6ebcbc295bc02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484099fde4f189155dc59d946453f1881cbacc6e16e289b68bbadb78644b8aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa22e3700f3853a4e2b2552edfbe9075725ca60080d3e9fb8302eab80d60637"
    sha256 cellar: :any_skip_relocation, sonoma:        "de74faa097221e2afb1baef5fed8ddda4ad61d00813cd91d8d6613819e43dce0"
    sha256 cellar: :any,                 arm64_linux:   "03d98c484b1aad7a5b3b6e1eab6a8094ad8748d88eb0a4de73576ae312e67926"
    sha256 cellar: :any,                 x86_64_linux:  "c102588c811693322db21dff35cbf8dba42dbde41e55b37fd63c88fef9d6c64a"
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
