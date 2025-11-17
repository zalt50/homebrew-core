class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.45.2.crate"
  sha256 "c979ec0887e959c6e619b2e2641c8e48d9cf89d2f9d013e36da41237c0f3a972"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daed4d344b9ba8741c896d9e3ad9f7e14cf708ec0ec34aecaccd89f203a58083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec663743fca760bc86d9346e0274eea116998e3d9746bf893912a02efa6a49e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6a69a707a2aa8fdddc5e8434e0f4b5aa1887c974cbb9bacf66f0bf4cfcef804"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1f8546ae8bbfb9a02b3360465f2dd507e0071d27944a7b257b7f2b1bfdb5b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3235ad75b3429c3858e5223b5f8dd5128d4f83467a234d2d2bd3331a45465cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8fb5264633dd644dc9cf6527a0c36691f92c3fb597a800c25d9fc2aac504f4"
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
