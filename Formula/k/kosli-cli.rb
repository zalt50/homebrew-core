class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "91bf5ca71d3d85bd5a7146340d36cb7f318acbbfe52b179af4dff1317a3e437d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bacfdc85d7ef1d64cb468a07e3c4ce0c51bb2759d469c78b8092c5c60c55ff77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b984b818e1488d02e0dc1b9b327f0d31608f8bf5265facd8aec3b68c52b3c91b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbbf8553830a2875cce51b6d08b7a224a46c82272166ea2e10dd6edfb5af36ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "56844db5f046c7afb185859634675c01ffcf58748a8e14b326f019d2057f359b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbc63d654341fc8ff3f39e1db82186cd1f9c5a77f693f2d9e8f0dac6752711f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bccbabc6ad3b3ade1a3bcc75785bf77611b2ef7d8051e1ca2e963f600593701"
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
