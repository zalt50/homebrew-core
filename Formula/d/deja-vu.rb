class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "c21f20bb2c0fe7b86c81a3d424246a495fc0b439fec92d27dad0c049b8e89465"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f517aec0439211b9e7ebb5f05990ac2bca9e6368604bf68d1e64c4cdc15cb55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f517aec0439211b9e7ebb5f05990ac2bca9e6368604bf68d1e64c4cdc15cb55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f517aec0439211b9e7ebb5f05990ac2bca9e6368604bf68d1e64c4cdc15cb55"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18efe1e31c3e9f294b24bba5b2896b69228a2e0175cda8139ba6b5b26cca10fa"
    sha256 cellar: :any,                 x86_64_linux:      "5bbb64db817b7400e802d0da40c538ab82700c82c8ed6b05fcb848d0ddbcf9a5"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
