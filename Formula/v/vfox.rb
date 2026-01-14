class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "988a97844402a01887dbdc45322b2dbc6e0db70005bd79b4b2c361377286cc93"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93e681be1cecf9ab27a7df6057b3e6d91b9fdeba28f128bf6732a65ec55cdf50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04d175bde663d73c089a0b970123f4ed5c51f870eed1e18a093a532f214fc848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b2a0ee05424f371624f9e047a37185e378c12b9d9e2d28b48ba2ca2fc1c7bbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a636b8d27d23eadab309d574198938f2605ebf2325a07c3446708ea073fdce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0126b54c3ad9908b7d0745140ae7bc657ee3c969a4c4f2034a39bdf3d234c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79135df7e5dd4ffd79b0104e24de933e3c92a9d8556009c0c3ac7284b7016fce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
