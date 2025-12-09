class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f123daba18f0b4d6f4623c618a8c8a8ffc27c4805bed903c8c4726e7f32c0488"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6affa0e0ba2c6bf81940961245bd9aa2590d7e88dcd4347d661b7be8de8dc354"
    sha256 cellar: :any,                 arm64_sequoia: "8d895b6bc0ee0cc458850d17cd63a24b93dbef721266761260de08da1115ee4c"
    sha256 cellar: :any,                 arm64_sonoma:  "1afd15e695db8fb354cb91edfee6eb628a94ee894871b2848cc54d3adcb17d5c"
    sha256 cellar: :any,                 sonoma:        "bd7a2d80933ce159fb0ce36e7245f6e545c17a95cd87e2c5db55539a6e7f1b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ed2d90ee28dab689ae4888f1863b27324f03fb4e081bbdc93015853517dc81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6992b5a89df10095cfa2d0a7bb10fbc27731822ffe0f4537264776acd190bc83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
