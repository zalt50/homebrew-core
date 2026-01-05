class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "a4983d74fd961097e30437b89035ae71ecdbdb65c0497bbc69402af94a03ecc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27986abe17bb7e4d39e9c2514a7896d26e738c9444b010d1f527aa7a536dcd7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27986abe17bb7e4d39e9c2514a7896d26e738c9444b010d1f527aa7a536dcd7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27986abe17bb7e4d39e9c2514a7896d26e738c9444b010d1f527aa7a536dcd7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f55e2b2f610a1c8203562de56a0559a71b025a0d62641ecb374bfcad1b3e011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "781e75a67f86bf1ff6c5150a7abb2aa4e943d7e56be0eb7f651eb8cc2ac69138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e126f31243b54fc3a3c0082bef83b778c3acf442a90c641190bdf7049664d5df"
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
