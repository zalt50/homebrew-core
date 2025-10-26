class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.34.0.crate"
  sha256 "609c9fd2a73a4c94fd05b458e83e7441de67cea9efe96adeb2e76527b16f4450"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "444437c5b3372ea093a2056874bf031e7d9960948f8c5fd5a265de78a6815e80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5f46c8469b0f3c05a7ca0267cc4d644c59f71db214b5206396cb1f93782920"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ba10fc5e79fa04c513f9d8f432c61ca07fe53cfc36a6684f616231675e8302"
    sha256 cellar: :any_skip_relocation, sonoma:        "a939a7c2fd2f82762cdd8fb49b1f4978c2aacaa3317d938dc9a95dda88c2f017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38cf089ebf6125935a318b96616cb9a4765a8c37d36a548260ce4cddad554ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cca45926bee2b5a5d05c1a8e6112e620c2b8ba98f3097c955d5f8e6bde1af86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
