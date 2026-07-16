class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "aff11d67c74a33e8f62643f66d648048953b35a5e894ca43d63f398b58523f2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ab72fc6f80839471ed2045ba55a7a72ab23e2d0d0a1071cc7ad6d0a755454c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e716bbb47a3e81c8e45647317c3c60fc7ba4972f133c2aa420f4936b0f154420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311861df437f10f602721a18d1a48042503ec996a08df94455983701d4180bba"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d4cd5ff9202a9ed2c5e388069636b29b324787b2634e5ee83cac0c4764ba366"
    sha256 cellar: :any,                 arm64_linux:   "78a5ebaefff03aaa3909acbc855c9b58d485b394b03e637ef7a8384e52c18dbd"
    sha256 cellar: :any,                 x86_64_linux:  "77c217689aafc0397d5d5526d4ce7680985c67894a3d7b3145db92338430abf9"
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
