class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.0.tar.gz"
  sha256 "98f58ea5b73996c1e619072cb101b98a4581b3c7f217c89bf9b32170f8c99a58"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da516c55298f0d97dca6b2764f0777c8f223713085f6bcfbd06936a89f226e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "291c6d8c922afd04452297d09c3e14e82b202926c5ee7f31b0c06749a8df6296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a32ac4cbac91e87b57c28796ba2851ffd93bcdc89ea6904631c0dab82f39f1ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9421b3c527503899139bbfe5ed62bdde24a09164825e7fc20ab52aa79d0a146a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ab8ff174b092c9c27f2fc1529fa0a61b244b31e73552f7802f7292f04080dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0170043a4373968d0a79ffabc88b5e34f3ac17e3fa994639fdcf6767152d89d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
