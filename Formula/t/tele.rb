class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "cb9686d96aa727f9c4b31d3d65a98c5f6196bd5dfdbb57f2c16612fef3302631"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "601d4200521ec13b2acac532624f58f69f412d4543bce3232fe48815cce5cb38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b107edb9156869d5d378109dc2f400923231e97a2df8b015abc63dbfbe2ab835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9caa352000cf50b0dd8afde54ce60fe47494b688821b328163a7db62d61a733b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "efbd9bc4df131bf1ce4f220c9595bb42df7570751d6e7727ad54d9a993112afb"
    sha256 cellar: :any,                 x86_64_linux:      "ed6ed1a01df2cc9f5ceb82796c44f4c84ed1289b2fe47a2fe7294ef0958ac3d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end
