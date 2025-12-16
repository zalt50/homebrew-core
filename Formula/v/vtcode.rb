class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.2.crate"
  sha256 "562d29d45f0d2b4dd6c6af6165676028754165b113c60ec028d385b94291dd6a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e16779cdd76db6c98e45e003521a6c5f5c8bc659ba191ccbb7e251e47433905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4953dcdc3011a585585a475aca3d6b78773ee4956055179c2707bf21f9c8a42b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b83ed0a8435e61102a6b7906c5e9bb58018a9ae9b90c72dbf66fd5feab8abbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "309a92c2ce070c2eebaf854a997fd847ffc79daf27932b810582a6bc7e0be7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61524cff83a1458eccd377ad5b45ca4a45824481629c230e59ca50c5e9528702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2168aca8aa4b54ac04f9d02d0ba74d602ce02eb0a6a020c707e9f225d87673"
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
