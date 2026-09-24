class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  stable do
    url "https://github.com/harehare/mq/archive/refs/tags/v0.9.1.tar.gz"
    sha256 "b95445ceb09821d34014d5fc7d90d25f1169d8ad2bec89c9e519bf416a71fa54"

    # v0.9.1 tag missed the workspace version bump in `Cargo.lock`
    patch do
      url "https://github.com/harehare/mq/commit/84bb58896def94aa74f8027009e453680d5ff695.patch?full_index=1"
      sha256 "6ec6a7301edc89fbea4dd519dee1d689c60f52af8be9fd7ed359843086403485"
      type :backport
      resolves "https://github.com/harehare/mq/pull/2431"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b179e0cdcfee7bfb63bbfd5796168206be4ad9723a28758eacee8eb8cdd4ebc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37d21b64637fd89f55938b701e9ddac459728705f08b7d423fa6890c3df50c6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d70b7e12243cdad5da7b6b6a395263e0cdea29aa9c9fd9f952cedc0b87c14cd8"
    sha256 cellar: :any,                 arm64_linux:       "a293f6aab494e5f802004c411541487078f5519701ffd1142db3b08b79984934"
    sha256 cellar: :any,                 x86_64_linux:      "c8d566ce843d3c393a9e270cd640ead26fd9de61e23bca04b2e8836662a43d7b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
