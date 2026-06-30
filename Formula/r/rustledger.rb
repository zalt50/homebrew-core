class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "65d8de88783eecfbf77fd479e47241b15fb1b7288877b8be73249cc9d75657f6"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f3fab9c3546ab165a40b6faedb9c2243968a5f22022f0637db1be174c57831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f97a2b30662c3a672842f6adc375eaebc2b6470e4027a44c40365b143845a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ece03f90c74b444ecf504e21755e4f78d90dac8879076dd32909f239fc29e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a6e7f7683574615fdf0ad31deaae9b40b35aabc58adbe0bcfc5e51594e84abc"
    sha256 cellar: :any,                 arm64_linux:   "75ed700631db2f4a1c002cc5f586a7791d74d7bd15e47c5ba9d368223938238c"
    sha256 cellar: :any,                 x86_64_linux:  "d445c4118cfc8b91a6a706c1f2d44d9eface2b8765ba02023c63ab2e0bfb0d93"
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
