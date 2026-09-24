class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "a549b8a72863c2ae39679ecf4b852772910d3d7f2a31682c2b79333e426e91f1"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d662831bd07fe7dcdeb9e791123ea55835f606bae4c1d76388989d72b84db77c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50aeafca1e127872bc6be69bd135466a1b913d93b4283bb9c96b06a883cb9cf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "339bf379a69229c8452a0603c265b40235dbc2fc7e1234c9e06d4aba1f28fd51"
    sha256 cellar: :any,                 arm64_linux:       "65f2f089d5269dcc03ad243985adec3afadbe816e6bc7f44789f6d560df280b4"
    sha256 cellar: :any,                 x86_64_linux:      "76585bc0cd399e8b29455f292ae3308f308e5b91fe7f73300980341d31a57061"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
