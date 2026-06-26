class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.327.tar.gz"
  sha256 "b8c8fbaf04dd35fefd973b7faf70dad40355f933af55f79d7f5147e299398b32"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54527d1ee1d82bd1975678a61c5dd267d8838a90439523ece074fd236bb46b8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54527d1ee1d82bd1975678a61c5dd267d8838a90439523ece074fd236bb46b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54527d1ee1d82bd1975678a61c5dd267d8838a90439523ece074fd236bb46b8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb05f702ea3206831c46deee4dcd23a9c4ecf6d0c66ac4a14c26c38514773bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ff75a074e76e520140f0dc8280196aa79f4fc83a83ef8149fecdfbaa4eaaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424903742e3ddf0dbd1dd61d7d90842feaec9a38d225fe6d1aabfc95089044e8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
