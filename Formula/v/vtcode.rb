class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.49.5.crate"
  sha256 "a6840f1d308566f5a954edd46f00189844dd8906d666dc6383b29dc1f4e93141"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f009823a212fe2361045a5f2c54311d5a1a0acc7e3acc0d7c54ca954e2fac1cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3f1b8ebd0dc0dc7529de831937a0b3d3fbae727126008c600dfdf489fd7818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8758ae5caf186031d5a6297c0f6126fc07a588f527cc392f9fd7ea2e9170ab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6360448c3bca036209ecbf4519f0355ee27ce54fac77276140d437c07f0304fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32e28604e3335106d5dde14ce8e37fa1d4ac64464cacb606518dcb64e1d53b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11b7cf8aedd4a82bc6bf2403dab066b5c5b1da37dde3082e24464d817749a15"
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
