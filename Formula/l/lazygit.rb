class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "9f714b3d35fa7cae5a2193cf11a2e9bc97bd0a9bbf52ccaea432765bf8f63f3c"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af6031f9decc7dd38f2b48373ea1e77dda123ad2640f3044f660394aa06237d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6031f9decc7dd38f2b48373ea1e77dda123ad2640f3044f660394aa06237d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af6031f9decc7dd38f2b48373ea1e77dda123ad2640f3044f660394aa06237d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "33cc9337263165eaf23330bffb4644e45d9b83ca15ddef0502d17d5c788a9919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb61cd02a4eee53212507fd80dccbd2654b0c591bc3a74f29daefa29ffcbb3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f4c51c9f3d5583f58ca17a6f2ea935240ef20d736ec0bf333beb37e000b1fa"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
