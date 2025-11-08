class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.20.crate"
  sha256 "9b4d306e41948756ec6891ffcfa48f4da79a396b4bbd3469e54232bb02d58447"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069ba68840a70c6d3ed962e0fa4eae6f2ccb4ff8f533795d6e268d5c34f27bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6949ebead95965a56d9c6b32dcc96dbfed7a9e7b50c35da11851f2c8ac2a18b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c268d4f5837635c02559aad53c1f452c02483e5d8edfca98c74a74fc820b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e8035d1ff2a742aa977172d7a466d6b82b162069b119f1c3a622a1ad26176e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15cd81813913321862b48c6baa4f9e50f0bd318b305803cbe6a82eea80c3a7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51059198763190a827f28f6a10dc04a14f09ef59f3526cb7e8c1e774eeb06ef"
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
