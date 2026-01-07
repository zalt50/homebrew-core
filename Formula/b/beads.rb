class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "7fe7db4b784e1c3223e7c7546b94c68a3f6f1921808ea0140c2f39252e7723a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cddff319c6779f7fefb575830bb2e0ce1c3d20602576669bb7fb7017ecfac80a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cddff319c6779f7fefb575830bb2e0ce1c3d20602576669bb7fb7017ecfac80a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cddff319c6779f7fefb575830bb2e0ce1c3d20602576669bb7fb7017ecfac80a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5ee3ff6d0c937f5d198b80e8025f43997a5d398cacf0d9fe9ee03ab4972a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8218f4f810cd4bcf331cb044a55974ae46a70979c06d7ffa005c6cb88a91c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4316f1b53e4e0ae2cc7d3c5f645bf872d9236dd1e9ef56a323fef825c549af09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bd"
    bin.install_symlink "beads" => "bd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end
