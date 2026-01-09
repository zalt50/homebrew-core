class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "dfba901524ba464b4cf1dcea86e9af49ded370400119fd061ca1b48e9a089cd3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a7fcf723413ffb971d0aabe4b8086d868d4f5aef81fc2b061f0bc150369da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a7fcf723413ffb971d0aabe4b8086d868d4f5aef81fc2b061f0bc150369da7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a7fcf723413ffb971d0aabe4b8086d868d4f5aef81fc2b061f0bc150369da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "81841a135a999c644715491278110c1bb3e261c6b74feb7ad52db7c741357827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54b36c661e3bbd347de5760c04412757effd7f05d0474589a592d5f6b7381f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd680b9a59ede3d2f90a9209c60e9aea472903d355dc9af1cf6c9eaa8ca1c40"
  end

  depends_on "go" => :build
  depends_on "beads"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end
