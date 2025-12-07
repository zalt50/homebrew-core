class Carl < Formula
  desc "Calendar for the command-line"
  homepage "https://github.com/b1rger/carl"
  url "https://github.com/b1rger/carl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "82518ea8fbd89985c40591a1b2c030b969829e9ce12ac52cd4923bd852dcd884"
  license "MIT"
  head "https://github.com/b1rger/carl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67619db42f304f3324f52af71184895920b2d14d7d0bc3ddcf9a5410f6a69284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aacff1cdafd7b3666449af76e70495fbbbb0cea021befee5d9a174c8ca966173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946ecb3c5558effa565bb0171e54b2f4fbdfffe4bb856b7494645ed5b50d1231"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f3751b7351e9dac043acdb36a57c6b171a93a2a84ba6c472a4ed5b85ed18624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a427118fd864b19041afd8567e9bc06154c859527eae71ef59de1d6ff133a970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e8fd70a8d03dc9f9f97835b51d3970a19890c67e09509acb563713f2940b4a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Su Mo Tu We Th Fr Sa", shell_output("#{bin}/carl --sunday")
    assert_match "Mo Tu We Th Fr Sa Su", shell_output("#{bin}/carl --monday")

    output = shell_output("#{bin}/carl --year")
    %w[
      January February March April May June July
      August September October November December
    ].each do |month|
      assert_match month, output
    end
  end
end
