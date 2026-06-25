class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.5.tar.gz"
  sha256 "11f008fd9802d519efe8267e944546fe1ee07f25fe2437e161c370282f5831db"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09a8607fb60a455f3cfd0be77c8c5bd9d9f459b43cbea7e34926ea5d573c3bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09a8607fb60a455f3cfd0be77c8c5bd9d9f459b43cbea7e34926ea5d573c3bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09a8607fb60a455f3cfd0be77c8c5bd9d9f459b43cbea7e34926ea5d573c3bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "698e9ab9da2ebd77c959f7ea020f187d4233c68b5d6f9497ea1cb7babde6c78d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d1f10c3c8c4efa9d2a5242317ddba9f623fefe161e454dc4dddd5c151935c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144accd3ef626e78662c214db08788dbbb47d6d5c519421b70687f205a41d06d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
