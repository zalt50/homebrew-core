class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/47/e5/15b6aceefcd64b53997fe2002b6fa055f0b1afd23ff6fc3f55f3da944530/ty-0.0.2.tar.gz"
  sha256 "e02dc50b65dc58d6cb8e8b0d563833f81bf03ed8a7d0b15c6396d486489a7e1d"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e90a97dcd8670866a263160458176da693189947f4cda2b7ab902dea6ff29e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16efe3b71832de13eda1db8033de6da031392c919bd849a83a6520a3ed1f1441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e5d051fe520d61fbac52ae20efb425dec0a87ed1c2eb4af3a44372ae52bfddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e2335c93130dcf5fc0f42bf8a9aabb9f90e3215781fbd03e0f28b4970ebf9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffa6038a48be93748ca2651f338c221feb5c5766fb99b7c514ae44122bfe8949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe94bddcb55f8dbbe4d7c442682cdeab2c9260b5fd4e12d6d39ec6a55d8cef9c"
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
