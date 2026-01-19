class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.81.tar.gz"
  sha256 "91c202e98b2d86e4d2bf5d125bcd6d33233d748a508a1365186bc6d9c88b6dfe"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6acbfd9bbc7b918d2f17c417c721e378b6cfd2adf299129b84dddae82db24be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a0b69d2a102201a5c1b16f9c3d8d95bf3ebfa00f9ea10070db5913effaaa9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1acebd6168f01974b47b999241a73705e1f3046f8a24b68f92882f4f598a70"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ae0301310c6779215510838ee0330f2a03573ddf0bf54a18c8b9ca1bd955ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbc75966616c4d967b6c0f38369fbdb1135ebc64c64232519b48d83c9d7d0d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06df0dde844aec256a1d72be426bdd56492db94d3fdb164fa3f0bcf6c877191b"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
