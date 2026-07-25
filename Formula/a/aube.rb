class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "75c2d4be53240962fdbfc80b3274f1c9a2281e4bf3ff7014029a6b87c67719d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e5cb8c696dea4ba39ff289e06fbbc0c38f3609e62c7651478d692589c63500f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f7b2dcc03a0cda176aca5a30454c8b65d75dea576f1595653da19c0b0e981ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ee6cc07e7da16ea93df4978cff500e701c4125c0203b99c71530f95c3aa694"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0e9351468f6a85dae7db9f16a729b280f9952c6a7b2e296eaac0a1db0cc80bc"
    sha256 cellar: :any,                 arm64_linux:   "4037c4e80df0abb1c6e2cfa144620b5683f492d3333d3d62b5ef6de06c805ff3"
    sha256 cellar: :any,                 x86_64_linux:  "3e0a3e428a2215cbd6a6c0d1fa77ea68ebdd08d6b28854f407fa737d31dfc401"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
