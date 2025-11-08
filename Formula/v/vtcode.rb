class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.15.crate"
  sha256 "0897848775b957def5487e766670082d48ffa1a3d62146f70f90018b6ff1a427"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9d8a9a0d0195743aa3de35b03a94a19c626c47497b1757af90a0003e18d9217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ba0ae3664235102f5e1876e46ff6538f93e90dd7207e8f163287d1e87e260c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a2cd8c24b3b0d90c4b9d5d8909bd0aeda226862002b94907a4e6202fb04a70"
    sha256 cellar: :any_skip_relocation, sonoma:        "59985709884ccee357d85790228e854c9eebbd68e41374e9629741dfc2e1a9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebf08166616c87b0d218ef0a2886ae24e7a61bec9c8434b37d2fa7373b0059e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36bf6151de30b909fb8695d5b5e2308379ae1bfef551ac24d5d99e6e2d2494c2"
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
