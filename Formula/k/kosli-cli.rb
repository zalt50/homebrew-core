class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "b6e4d342cb974b060837271a703f25919b1217db76a62cd11855a421e3313a04"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78b164bb5d4daa143b149618fe30252318f2493591c7dfc691585ed3c4485225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "569dd869e4acacf596fa4fa2870c319114cb0f6d61e7b4b00e1190a41e10bec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c12e80bb32d4fdc3c405026e82c5dada518dfb999ed9b7fbfc1794baa673894c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c39a0e32c61e21cbc473f44d7ddc3d95b5a02c77e82838d8c6f9127c8ba14650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5acc94bed40e63570ea22d8eb63c7d96612ca98b78610cfec678934caac0f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7168019b44e8202f8686f10d43ba475455d72c2a56025f5d05c86d22404a7f9b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
