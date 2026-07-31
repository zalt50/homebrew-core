class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://kfunk.org/tag/icemon/"
  url "https://github.com/icecc/icemon/archive/refs/tags/v3.4.tar.gz"
  sha256 "75f79aa21e0524e384c9041b558d3b55ad5e2ce9a8c851d6c7ca94ce0bfe7e9a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "d5e4c9d47ec2de4753b84249d420914f615537a8716a8572766bf2f55d537842"
    sha256 cellar: :any,                 arm64_sequoia: "780134490d63035a304cce1c56538ddce1dfe02ee84ccc61b99a4ad55d385e7a"
    sha256 cellar: :any,                 arm64_sonoma:  "31a6bdad5b6498e066f6538d31aa06d544bcd6a6f21190ef0437303a5c59f577"
    sha256 cellar: :any,                 sonoma:        "a6a7e36c351382149cc4bc6f38d02003b62de21a0dbda312c4416314a1f61dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5df5590435ac125e895909b3e5c476db1900ff8706f1ab5a89917c5edf1f5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77bec647e7e05d5261669d24196f3cc83f86425df31ca9558593461b45a3bdf"
  end

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "icecream"
  depends_on "lzo"
  depends_on "qtbase"
  depends_on "zstd"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "libcap-ng"
  end

  def install
    args = ["-DECM_DIR=#{Formula["extra-cmake-modules"].opt_share}/ECM/cmake"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.mac?
      system bin/"icemon", "--version"
    else
      output = shell_output("#{bin}/icemon --version 2>&1", 134)
      assert_match "qt.qpa.xcb: could not connect to display", output
    end
  end
end
