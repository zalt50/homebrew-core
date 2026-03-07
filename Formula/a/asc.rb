class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.37.2.tar.gz"
  sha256 "2e36814ab6c7acef91a3c2a64d0a39ab7f7aaa09283267d3254d6b38c099f48d"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d694dc1f39acc0ae3e3ecce14becf68a7ed140192fae538f97457832ff3d186e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6f836cde2541a53a43cc12a001896ba8982e4e5174858756dd1b8bd3aaec5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1341f58da8b3fd06e4e6e03212074b12692a85b4f70c06c77917467e98eff5eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "83376f7b52474641c1fee06bc6546b690111bdc488752592a0ba1f4fca6399c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cfdf4feee132570062350ad7e370fc8d59ba65f09cf59693c46dc138fe1679c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72db97fb50f0c47b3cf60f82293fa4ea4473ae88f6daee4229adf250f44ca4f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
