class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "9afd0b11a60100cd73b9b6bc8407d9bda86ea5c40529b60429db56efaa3ee7eb"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d9bb9d31785319e3f23af241f8f3da5b4a458cd32ca955809aa27ce020ee54e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000e9b8f2990fee641e2b26b96a8b5cc44d506356557936eea05299d809eeaa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c38ec955ae82b36c9961a7f921d93b41e3e02e7cc09cad2c4a864da7ab03c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b7ad9f280fcfd023193c6e0c68656c2ebbc9a801df01879b8a1a10bbcebe99"
    sha256 cellar: :any,                 arm64_linux:   "96adc4e0c7215ffe49fea18bc193b4d07d4209a0a06d719c31cb62b8cb0e1a39"
    sha256 cellar: :any,                 x86_64_linux:  "0f628efab157ef345c9873e98e90565d3cd550da6accbec7e20ccc9789b6f46a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
