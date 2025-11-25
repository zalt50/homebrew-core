class GitXet < Formula
  desc "Git LFS plugin that uploads and downloads using the Xet protocol"
  homepage "https://github.com/huggingface/xet-core"
  url "https://github.com/huggingface/xet-core/archive/refs/tags/git-xet-v0.2.0.tar.gz"
  sha256 "551237dbed960265804c745d50531cc16d8f13fb31e1900c9c6e081bfab01874"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^git[._-]xet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "git-lfs"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git_xet")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xet --version")
    system "git", "init"
    system "git", "xet", "track", "test"
    assert_match "test filter=lfs", (testpath/".gitattributes").read
  end
end
