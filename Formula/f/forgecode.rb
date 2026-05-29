class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "7a35b001713f80309479889cc874391e3be6031c0d2ecb4f294658f514709fdc"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b0552f9a759d78f5fcdd49920d25bea3068d50fad71dff11a2025bd43ac7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b951b06a2e7265338889dc5daf7e755e0519f5a52b9790382ab2e9eef701aa09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d04834833f7b2087b11614f2d0cebd6093acb4f1e35c56a1fa2d5a7779c4d03"
    sha256 cellar: :any_skip_relocation, sonoma:        "83399f288c1d1d6e0ad7c2e1191577232c19dd687782a0d16bfd5d5c958fe783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b269386ff2e6b9d4f30c59961c68a6dfbac35cfb940053296cd3c14ac65a855d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171ba589de105d3e74a224a9c4b012c4bd70d749b4c9f71d2ff32b5b1fc4c0a0"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
