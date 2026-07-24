class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "352f9da1b943cf2f38f61b6dc3176e9dfb97c0a7f58e5f04dc250c0ababa96d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aee2c9b8934a7d818e1818fc11f012cd9f8e7a32d33bd323ffac9f14f2f593b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d7aab23cbf08cb5da90ea1b248d87bfdae6475dbfe4b4e78a1dca7693273302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df07784f7a0f1669ea01f159c70215697718b07b205ba5607139cc926dae315"
    sha256 cellar: :any_skip_relocation, sonoma:        "02df8e716206527bb8f3359f2ca38e04b2bc8e613304d19ac3875578c6a37611"
    sha256 cellar: :any,                 arm64_linux:   "b9ff992e9e9ffd8bcf7bd1e8b0900c2465f894132ae4fc46b426ed07b2acef52"
    sha256 cellar: :any,                 x86_64_linux:  "cfc84a97a7d0a255d1ac5a8bfe9cd4211f6d2c5dcf445eeb131ed54d6e301e4f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
