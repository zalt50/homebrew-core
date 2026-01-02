class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "857bbe49ee0942e3050836b5fb44d41c97c44fca0aa27b3e2a0c7db381558e66"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2c359f0b9b35a3bbb677678b2f3e9204386f8dd61a726cdb1ef959b62c631e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da393aaf97ecdbaa18423ef532ae109e1f4633a7f10a6703af45bccf66708d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39928fb081cddd631526ce67531b92ddbce18cb23d2c543f4a99393628401ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a43a288f7b6a6f49a121c31c5edfd519c4613ad02e965e5eee58c68c27d389a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26c75d56ff17411d448200bd0a301b9b34815f868587f2493ecc93adbcfb6249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e98fd0776a5c4c9f58a7d728a52a8762623f2f94438864a7368eeb73319bec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
