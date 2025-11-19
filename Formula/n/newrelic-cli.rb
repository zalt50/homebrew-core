class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.7.tar.gz"
  sha256 "733d0cf7908a76f4c7c52265a30ff1fe786d2a0d5b205771098aff7149885126"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "523ed7107b3f2f112842c628a091ddd1e67bf646f2f78655192c7fe4320ba33c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4637f322289103d9271ed6b918cc7a8f64cb8a88c5dbe36f6af5aa5a2c76b64c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904796dd56e6c3e1eecc17c6aa4f1fe927ec93f207b4d4849d52e5cd91af8357"
    sha256 cellar: :any_skip_relocation, sonoma:        "c941b0c96247bb95febb5cbe25e440a2190816575ae89f2ccd2906fe5afa74a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373dfe0cb14e0965341e13a85126fd1a64e89e69c54daf6d4084d6cd60efb9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48dee76911adecd3f546c613a19b3be0c6670aba95fb56848263c296912aff9"
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
