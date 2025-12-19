class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "d6676b678105517a183d878180b041f186cd45a5591a2a7f25f30d5c0ee17670"
  license "MIT"
  head "https://github.com/jesseduffield/lazydocker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb7058b0353436d3208ae20b176bf30fb17478c2efb93ea01c1f75c8ea639e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb7058b0353436d3208ae20b176bf30fb17478c2efb93ea01c1f75c8ea639e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb7058b0353436d3208ae20b176bf30fb17478c2efb93ea01c1f75c8ea639e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce69575884084a6668f2ab9b6f6c090f4e1488fd4a5ec0f05739d7baf3840032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc09b539890ad3d4c4dccbfddb8657640d4b05184b0979d73c38006a5ba28e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65119199788b7a1de96ce259ffc1f9ee3256f7317fe20ecec7642e640f2149c4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
