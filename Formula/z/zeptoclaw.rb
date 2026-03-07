class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "896a7bb3765e017bd112d4e9a0fcb85866f8a6e9bd6c6c744e1ae010a55fef65"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ce8a19a4fb0061d4b620d94a57a4ad10db4269f8c963a09cfd1e11de3a2c34e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc4e02e998474ae3fd9bbb45750551920d372bcf3ca82c0d2ccf17eea7b41a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c72f314910984d6ec8a4c33e3dcaa8261b999749b7efb91aec51580a3a68a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b82195e029ac12eda8aa84b95e04fed53304665d29a498fee3bd9585e62c303b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305ed4570aff4220f0321546d8217b47fc96bd478d9bca2e4c235e050d72c07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f189f531fb61aba1b9244f11b7fd615be88ac9d6a411decfc92ba93c2c3f2173"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
