class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "51aecda92a1805f5344c30bc079f23562ae659d7f58230dbd1f2b9274414198e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00e0af19a857b0bbebac1b774f3dce44e5406c3f09cfa15fdedf7d75e788dabc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66acf1f03d9edc905370fc562302a319cc2e073cae2c09b1ec5b03dd1609d248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1364628615a4887b8c890ac455c516e2a33ca9202d76da2004ec3ce6fd954b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fed40188f7c4d49649e4cd1a772478b944d3352c535620a25c3f1518e267631e"
    sha256 cellar: :any,                 x86_64_linux:      "139cc786d4ed4abc1662cbd3e26027ecc58b75e2f90260a2189bef3450f0f0aa"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # `mailpit version` in the `test do` block checks GitHub for updates
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "--offline", "run", "build"

    ldflags = "-X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    test_email = "wrong format message"

    output = pipe_output("#{bin}/mailpit sendmail 2>&1", test_email, 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
