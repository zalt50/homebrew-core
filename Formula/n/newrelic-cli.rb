class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.0.tar.gz"
  sha256 "268ccbb349b0aec2523116241d49fb993589552afbc5f93e677739e7cf1ea4c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b13a7b91b4e396e57c17c7dd5a5385e2af71c292e0853f7d4de0deec4f00521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2402a56d59203a6fb15dc16c19b6c8720975fe7fe638d124ee73269dacf26e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e9d3ae6f004355c1700586cc0bfb59eb9698240182f133bfad976fce2618171"
    sha256 cellar: :any_skip_relocation, sonoma:        "86d3b125a22b9f53ff8cfdddc28d8d133d77374f6a6a328d3a30383f1f88e4d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db33c58a6574eb3e16030d4067fd37e6a4e4c28769bab325899a1a008bb4be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6644d92433ffa189f0d580ce026ebca0782083297507b52f53ba70f5669b29"
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
