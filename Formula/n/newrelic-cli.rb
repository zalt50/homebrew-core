class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.11.tar.gz"
  sha256 "752029a117af65cafb9537fc50b9b2a296f90952bb7a469c5e5d66c4e53ac420"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23c2d3d9fdd0f4af004b251a95a19bd88efe7f937cb93b6b6cfa665c2b95c6c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79168807b53225adf40881f805c6bb792f1301943d6ce5730f1c8791aab6b0b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c31302625c71ddc558ab2c7183fb10fcb8703a98f363eb347f2cca3bd654701"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca602d21ec79a69a48c7393edbf4deb5b979264e2e829e1ee5ff9ac024cc176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5708e49398f916a57f5a3af3b131b22c29cee6971516a875e5327eac10681049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0435dca4b9c6c9931cdd017c6586ad32a4842506704d16c18e20df8c871a1d9f"
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
