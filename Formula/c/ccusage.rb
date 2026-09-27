class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.26.tar.gz"
  sha256 "ac356a431bc8703ad2548d5913f2c0797b2ddfeb0058c2afd7235796159f5002"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "910fb1d30a51d5b08e04e7349ba8cf23d8f44433959263f6122485c67407255a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edec62abebc3745c53e512e38b150e88089357920da93bc08c61cdca9dbee2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3679153d327417b80c7d8c8fd5c89573f547a0aaa282194165b6e885444cee3"
    sha256 cellar: :any,                 arm64_linux:       "93da6373fa1c83b070f147f7b0bfe4a8664f3ec6462ddbff77c7d327e3e79a0d"
    sha256 cellar: :any,                 x86_64_linux:      "309523d1afece1ef00ac9f6767349324daad9d03ffc15c30915723f1f9c5598b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
