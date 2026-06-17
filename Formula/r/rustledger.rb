class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "cfd6c316cdaa150504ac4c1406792e0b4bda059328e42e775b8d3e5912faa65b"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57a851a42accc55ce51841a223258647147af373694e127b3cdc16cc6e20f719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f22aba3a17791cc88e5b5accfa0196fcb45ae483f8761dc85d9c6402e6f940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4891ef13818222821915b055ff56695055fb3fb2cfe322713a8a76d780e4e7b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fb62b0d1b186fbaef43cb49cb631128b2e47e7d9cf5ea548ff244e72a472882"
    sha256 cellar: :any,                 arm64_linux:   "e428cf0d6a496b7767c63a9cd522e85a7d39ee93e26cee33d909da6175faf844"
    sha256 cellar: :any,                 x86_64_linux:  "6a5651f855138661a28b6b6d9911c94fe43b1ebd7517cf3fae23411223d70c5e"
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
