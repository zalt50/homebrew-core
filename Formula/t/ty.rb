class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/5a/7d/d95b5a9dea83472006be3ce5e480028c44b34138d84d0172e910f287fb69/ty-0.0.46.tar.gz"
  sha256 "c6c2d7105b5633b49950b4c3a90d1ed2613eb9d794ad582bbbf6c4ffcb93accf"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b86fa73ff1a48464afc8a9a307af6a96c2891ac5c08b54b17a73aedd94c9f6ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9fb08a23acbda686c8fe0b535f6159b6161258a6faa38f8fb458942fee56179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d13db82d30bf6522fd23d0dac09cc79de0c5c764c6c38212b8e7cdb3add63ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f77053ee8faaca4cbe397805b985ca7dad033d0df9a166ae9a7e1097e915f31"
    sha256 cellar: :any,                 arm64_linux:   "e2305fb7ba5e9c0e2bcd3d9c4557df5fc442a5bd8eaf1102d664d3be85b467c7"
    sha256 cellar: :any,                 x86_64_linux:  "ffc0927a20de3c797ca4d1f29274d90b3023fead470c9aaad4aaaff5feff14ef"
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
