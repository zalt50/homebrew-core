class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.9.crate"
  sha256 "a0f62c12456ffa03234f19961d04fe7ec293ce0f885701456a187813dbeb882a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f18a1072bc9834e2a0cdfed91387256279a6e043f998e9ced592a0101d516085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9026d80adfdedef13ac8f1f0ca95964772b6817be874ea312e1bee749e547bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76fa9bb16b669a5df6d2d3f76841e6bd41ac98968a73eb903d40b1fbf91ce2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "89fa4d761c349cf431394b7d758a0e08f7b13ef776f77d9f7506c3f700325f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5885ad4327bc7cb579bc07b6699cdcf3ef24b01ae9912f2fbd6b8a9cd230ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c6db0d79dc35a8d8b7b8449a5d635c7af3cfc3d67f84f4690fbe2ada8a1c3c"
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
