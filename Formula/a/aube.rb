class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "d1b482b2737858a736667ccb5b6c07eded6e982e97534dcdc2fcb872e54adf2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "601481610775e5a8182589116051a2749fc0bfb317c2f9ab3b7ee60b7f12080d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ee14fc191432bedfa15c244975624fdd086e7008cb2a801997699c2249902f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d9690fa417e58996edc9aba8b71a76c5d3dc4fe8d187cb84bc8c14767b4109"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1184f6477c704004508769af59013801993390478df906b06ff529d4ef3281"
    sha256 cellar: :any,                 arm64_linux:   "fd6dd809f2f91421b2e08831f4d0982c2eebfa0b0042fa092f87daae06da9a32"
    sha256 cellar: :any,                 x86_64_linux:  "25109542536a4a3529765a249ed6c7be0f29634ab915492540a141b0607f3009"
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
