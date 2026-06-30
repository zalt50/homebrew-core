class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "3cf8d562b5c844a2beb8a692ea62d19f717a15e277e836637f32f548a4eec03d"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5191eaa2fc264723b0e68c3a3b7fe5826ad598d840e0aa666be9bb1784b0a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497c7db4e4d7aa06b9b325f415b1bcb98f30c65d737c03bc1a4ec2e3bea80ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1223a88105320d4e156ad24314c2fc9881810a1e895edf350eabc6f193fa742"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f168ebeba9e8c72a17e0603960f21a480f6253f66d89ffcbf2b2c08f26409f7"
    sha256 cellar: :any,                 arm64_linux:   "c4ea16bd1de9a5efcf8c274063975674c38ff041f57d8eb8a7d535aff53ddbb2"
    sha256 cellar: :any,                 x86_64_linux:  "1c62d4eb2beaa1ca32b0fd846c1d0d63f93c19795a0fb9c5b2925916cfca0a7e"
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
