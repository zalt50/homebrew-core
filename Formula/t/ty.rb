class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d7/e6/6dc6cd37edb5ce3346af6a1db7477b01210057a0e6dfd978b1b50dae0d3b/ty-0.0.1a35.tar.gz"
  sha256 "b122986b36a7e7482943312026948e67670f8f252bdf1afa5378b1a59372c25e"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fef68b492b3a43afd1f17320a34655541a269d6ba9cba76afe12307a67a61839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8f8a1e9aa2cb7256f743fd9a8eae846a333867cfd6940f6d5424ea9be27843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5e3c415c4f797a0a1b22bfc0b97fe695e8d17425c524c312910cf3d4ec7f186"
    sha256 cellar: :any_skip_relocation, sonoma:        "3451fd9d8f3d9c360e48e33fea6ca2224ba3798050e49b795f36e7f825bdff6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "900d81d3c0e773cdab81da97edddb0a91c5fd6f1c190b84858ad5166685ff9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518caedea0852c2a77a61d9904fcda0a79234b1795143748b7afefa947e2b60a"
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
