class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "2cb82160a34e5be09b81bc1583f572bf5e1224d23a61baa11616f0a4ed9c1eb6"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4caa49df5979bca2250f471fb5e688c73cf3fa8d4c516d365e24a0baf7d63e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88cd4f964a1605e95448f1f87929de9ca88df739682a8e21ee8cdcefb1aa794a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41acb364e8c86e8d847b91de4f849cfb04e9e942748ee663d9c48b8b1c254813"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8f93914776e0c3577a1a8cd850c2004fa2ba71afc92145bb3c2d3e44dc793c"
    sha256 cellar: :any,                 arm64_linux:   "ddabe4e0407db0ec6e9f9d278746c4fa423e3ad5b7bf13399e23abd1904fd1e2"
    sha256 cellar: :any,                 x86_64_linux:  "b17281e383270cee6294a97b60ad0cc4ed121857c9e22f9366153060c818e351"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger")
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger-lsp")

    generate_completions_from_executable(bin/"rledger", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rledger --version")

    (testpath/"test.beancount").write <<~BEANCOUNT
      option "operating_currency" "USD"

      2024-01-01 open Assets:Bank:Checking USD
      2024-01-01 open Expenses:Food USD
      2024-01-01 open Equity:Opening-Balances USD

      2024-01-01 * "Opening Balance"
        Assets:Bank:Checking  1000.00 USD
        Equity:Opening-Balances

      2024-01-15 * "Grocery Store" "Weekly groceries"
        Expenses:Food  50.00 USD
        Assets:Bank:Checking
    BEANCOUNT

    system bin/"rledger", "check", testpath/"test.beancount"

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end
