class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "a7fc752afb68a909fa8d42bfa527fc44455000a089eb7448dcf264c3950ab797"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87a205cbc417052a848542ede9a6a6391c4f1c3ed167096970b4a1bb40cd72a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74344d5adc97573cfba100a19712637f8aa8d12d8191d06487ccd389a2af8ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da7833866553a14356a4454173c38e56e77798686c4c91b047f6585346cc0c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e947c397fa34074886859ee90bd16dd075658995e219f6cf4baf1a33d45eb40f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "121adb06ec7a6cb89ce3ccabc0dc46dc2de8dd220a08f2a154c752f02592d3e8"
    sha256 cellar: :any,                 x86_64_linux:  "acd00950ae444a034a4fe4c0b1195238f20a08183c591632788627298defb77f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
