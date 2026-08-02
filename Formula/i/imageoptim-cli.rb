class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/refs/tags/4.0.0.tar.gz"
  sha256 "29a6d28984273eb70ab8be03ea028a5b7285b051d442598e41bd77306ead8f52"
  license "MIT"
  head "https://github.com/JamieMason/ImageOptim-CLI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a773e296348e3eefcf67f3b5101d88df39de5a2cf3746ddc67bb14542620c105"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imageoptim -V")

    cp test_fixtures("test.png"), testpath/"test.png"
    assert_match "test.png", shell_output("#{bin}/imageoptim --dry-run --no-color test.png")
  end
end
