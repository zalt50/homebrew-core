class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "58760d7263ddfd40115500feb550951926ce7ba3bf02a28ceff89332d2745d79"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f588e3b2f3e2622f50090f79c76c3a6e250a19a088ad57fe4b8c2b75ffdc6378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464fa4542091491058a94e3a8a8c573d5e549d3511a148fdf0b3100beab4cfc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "076a917e8bae89cec7ded12c8cd0d3e87c523f13019c8968459c59c082d1a971"
    sha256 cellar: :any_skip_relocation, sonoma:        "80cd2ed9f3e130f4877470e24c126cefbeff76ec714d28eb7ea0dea83a2aaab7"
    sha256 cellar: :any,                 arm64_linux:   "34efca3e62fc5a13dafb0cc6ccc2751b0af8ef4c21a239aad81f90105cba394c"
    sha256 cellar: :any,                 x86_64_linux:  "54eac09cc0ab1c7662faa156eb905b9d50b038ffd5dfe9471bde53dc3475f942"
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
