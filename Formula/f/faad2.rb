class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2.11.4.tar.gz"
  sha256 "ee479ccbae4a8387ab696e6f21a481bd83fe3881471cafa81b4ae59d7d3aed43"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "384a3197cf15ea0fba31760f8bb1bc5d30d21f0e73cd4fe99ea0cc9b49928760"
    sha256 cellar: :any, arm64_tahoe:       "b426eb979af4a59a6c22dcb116c23fa9908b9fae589b9caacfa26a596c9d6564"
    sha256 cellar: :any, arm64_sequoia:     "680d23c1d1fe56bebe518361aece7bda88a5600a38b110314f1302f691c80083"
    sha256 cellar: :any, arm64_sonoma:      "bac842107b966d64277456f353213cbcbe2c87036432a750aead01d641e4fd08"
    sha256 cellar: :any, sonoma:            "84afc159bc84a55df8b3128bf247817c26d97924b319ae7fda92d6f6e80143ce"
    sha256 cellar: :any, arm64_linux:       "8df72efd92fe483e9e91baa81b787c4ab539af825f321a7862b73d8b470c0531"
    sha256 cellar: :any, x86_64_linux:      "8d60ea4c4b02c5577d671ae3311ee173e48e9a5b51bb376635b2109e362f25b4"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/faad -i #{test_fixtures("test.m4a")} 2>&1")
    assert_match "LC AAC\t0.192 secs, 1 ch, 8000 Hz", output
  end
end
