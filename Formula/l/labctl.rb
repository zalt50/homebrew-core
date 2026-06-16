class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.88.tar.gz"
  sha256 "618e21c1815f7d8e53a2893c58e3cb1b662a068756c8e1391977d344d73e4332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8404e9643c9d3d10f26b3e7b04ccd59c349bb2d83c60597090085bfe1d447ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8404e9643c9d3d10f26b3e7b04ccd59c349bb2d83c60597090085bfe1d447ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8404e9643c9d3d10f26b3e7b04ccd59c349bb2d83c60597090085bfe1d447ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad426f3ba7921afa5815d5de9b91950ae3c7cc94ae94842737b967cfe8a2290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3808011b1b0a78124bb067c1377b2b4a63fa804aaeb8b9c16735f2812a5901f"
    sha256 cellar: :any,                 x86_64_linux:  "2bd682fcb6100e2c974abb87259fb94aa4e204a204e8f31179f75228c6dc814b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
