class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.114.1.tar.gz"
  sha256 "e13319743bfabbaac512fe7a12c11c89dc195903b7684e7db7b3a73b24107d91"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06aa3cb7a9b637a114f4bc47c2f8d60be374009e6bff52dacef025a11539b2d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2598b951f849dcdc15563c1e2a0b200992e8fe15efd970693c17dceb8eabf128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ee5dbb914807f3ddf53996eb13ec5e2172be5e7899db9432157481b47bcd4f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6db8ee60af7ded8552236b5e2ef7ca8ea1250e7db20dc237f96debaf2a9a7961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "42cd3d9e52c3feddc00048271106dfb7200e8e9a338425b5a6b522bb8ed8fd2b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
