class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7e7b8a99b2fc29a67ca798726376da59d58f5c010f207ff427137541ecbbe8c5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5319c1aa9451c7a84a857a910e41c072cb3d4abdec88add35707d247414f35bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63e20fce33644f61b8e731de0aa1a74f440dc8a9143cb16c3aa90391b36a29b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7265a01ec58dd498e376c906e450c58dfd0a45faa73d1d503c4e50429283b559"
    sha256 cellar: :any_skip_relocation, sonoma:        "3259b8f7c5b339e1cce01165d0889cbfea93d67a3ac0d0d4088a33061633bd0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd2a9ca8f83ab9c10366f9992809212e787de7d9c92954887b77432d1ea15d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb872054d6ddda78ee243cf58b323dc2d47fd3e96453460487afa8e735c7874"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: $DISPLAY variable not set and no value was provided explicitly", o
    end
  end
end
