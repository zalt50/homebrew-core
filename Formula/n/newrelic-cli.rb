class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.15.tar.gz"
  sha256 "e9720bc84fc1d7b7ff9bc733ccac93e72bbd5725cea6b1466ff24ade414e7da7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca230b13e9b4fabbe3704fa30f8a1e101c8edeb2cc8d36645e92345272777c9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59ec79a185958f4cdd182421ec0edf23cf6f3f5813dd172e34b54ea5cec6e9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "076018774c86e86fe00a3c67055d5b4cee936b9f44d592495759231330095c2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3951d747c65aa6d36afad6f70012b7857d5094b8e4a2de134992244a210d29b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98235c3438c1bf2cc8a6ee2883a12a9055dffad305761745838849b544489365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c7aede2874c08a7f6cb069698f9a2d1bffd065f879b8a2b482b087471a9ab5"
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
