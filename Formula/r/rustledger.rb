class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "0bcbed0027ea28b60a03ba1762ed29db9cc7a146333031a47f8a3a09f4eeb227"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dd22954f3ab79d99f6d7e68c026cd488e89e77268ae27903cdf83739891f36c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a5ed97a57874a17dab62d91463887458e1617457c9a87d7e54568bfcccdffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76df2fb9dabdb555ad490c101a728340c599aef6becd3748b08c0b718933d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "205ac9e1e737aaeb380b4d0fc8f15f705c41bd413bcef6e7dbaa7cf94decbce9"
    sha256 cellar: :any,                 arm64_linux:   "477d28c31290feb35b1195c3c56192dd15f85521b5cd129c20b0d69897067641"
    sha256 cellar: :any,                 x86_64_linux:  "e9d3bbc6af074b93c826a423f7139fc267b8133f1657992208cf65827e6c87ff"
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
