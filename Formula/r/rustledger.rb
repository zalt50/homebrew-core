class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "9ebd6288e5148414a57628daa51f0af45b2a6a4985f89a13827ae021bc2d2233"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6418ba99ecb5df8528dfac914851ce2a4a6138e2c8d21dbf39cd5f358d63e640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac40220b251468f7a9988e411b9cb6b7a4380f81dbe948d9fa03cd1fb37cc6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d464a52f5a3499c7050fea6c8587bda17869e9e032780bbb4da0b8c5d28cc16"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc7ba1a1be8857f81c7eb22e3bbb167295dd1053188e8a103a0270a0076145e"
    sha256 cellar: :any,                 arm64_linux:   "2785f65e8640bac96d68d731a64cab89e2f3b564e5fd343628cbdd1fb80f24db"
    sha256 cellar: :any,                 x86_64_linux:  "6afc5ab03a668df57679ec0b228a4b1a0af8482064bbdc184d276021a61d3b86"
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
