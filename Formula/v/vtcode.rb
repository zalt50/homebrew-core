class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.39.0.crate"
  sha256 "e60687b59b9cc10e570f6b702d602ec2e615b33093aafa03fa426303f2612a5b"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ab65e8c9812a490f7ccdb1e1f00f2aed76e4b5b401f52eacbf5d237349e4af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d9aae401a5928cc0cbd42f5e6f268e529a1e5a90679676614dd17499f0f967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5693d09223fe3f4d36113f0ddf6b69b0ff0e82e3ae067b6731c6faa5187afef"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecfa8c364fff95e13b4a7ac21374307735ca2e23e2c17c4fdd3dd2c54f11dac9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d2efa63fbb0dbe022df6110accd6ad0b1847e98ccb5f25b71e8db193a6c6d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d860862aeb4cde226168fb48f062a3e1a06ad09cbc807c89515ebfb1944132"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
