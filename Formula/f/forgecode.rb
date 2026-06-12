class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.8.tar.gz"
  sha256 "4315850e1a0955a6a131315c7a25a78f10bf164cfc877fdc43751d3077668450"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46149f95893a8e3b91b4204c3e8cc29198c22df542ee31c67d75c3413f42a792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe201b1e885326811bd5d441d7d03375c10fd08aadd51c67cf85666f5092703a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc72280cfc47f7582e7722913ae035c80cbbfa27c79d336d2b3c32cd4f0fba3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d7929d1da7e9cef1320b5c713d72f1d25d2dfac897aa295496faf982d5549da"
    sha256 cellar: :any,                 arm64_linux:   "96f1984a25162895231118bdb62620da4b652c9c515b9b64b4aa1982c0828fc8"
    sha256 cellar: :any,                 x86_64_linux:  "54cd85e8ce34fcabad4a35e36734937cbf374da7ee07d9bf7b8fa658935b4518"
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
