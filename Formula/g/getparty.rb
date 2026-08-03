class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.26.5.tar.gz"
  sha256 "b18b4e3f19f5f0c50f02f01cbeef8dfbc8138d0a1bb32ff716d8e6db5aed6b6a"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d0a1f9a231d141c9dc7d9613423f3fe90fe7a9f2ccda81de461b29bab62445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d0a1f9a231d141c9dc7d9613423f3fe90fe7a9f2ccda81de461b29bab62445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3d0a1f9a231d141c9dc7d9613423f3fe90fe7a9f2ccda81de461b29bab62445"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c838ada429eca56a2a7d04c0899bd9cde759176fb5906787e39dbd63773b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9636acea8030a915a2fc238f081c606b8ad2d8f2c54bf7f10c14067208ec22a"
    sha256 cellar: :any,                 x86_64_linux:  "27b249f83b154cadf63fe5185e2e151c16a67da68b2b7b433aef4fcedef6a7af"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
