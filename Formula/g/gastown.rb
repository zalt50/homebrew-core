class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2c0bc95505675b74586bd8cbcd7e5f13c9b8bac1d6197899e76c6ee84df1f8b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78b5a3ff5c2160d336324e42bdd8099226bcf7f1d0418046f60a8d3948f0c33f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b5a3ff5c2160d336324e42bdd8099226bcf7f1d0418046f60a8d3948f0c33f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b5a3ff5c2160d336324e42bdd8099226bcf7f1d0418046f60a8d3948f0c33f"
    sha256 cellar: :any_skip_relocation, sonoma:        "295e00e1e114295f31ee0557a8fa66383edb7a8bfa25e4eea67e6e4fa23c5a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "870c99956616f6ff8b2b32cc1ec68a2834732342d86ecf75d79b47a5db4bce7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad0ae976b5d4cac8b0baa430f5979ba5b4b54758bf0e6b239fb0899953aa206"
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
