class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.102.4.tar.gz"
  sha256 "41f6b53d27d79e23c1bc95df789392409cdab545472799b94aa4ed33afcc51c3"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9406d39d49e133ae55764df7d2822ce8dfd6188ef052251974160b1c720f2354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9406d39d49e133ae55764df7d2822ce8dfd6188ef052251974160b1c720f2354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9406d39d49e133ae55764df7d2822ce8dfd6188ef052251974160b1c720f2354"
    sha256 cellar: :any_skip_relocation, sonoma:        "66e1675a875dc216e971999d32ab7557c60e398f969cf9ed9efdd8df9be074e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a8e8869e1983feac0271ab7bef3978e92189a1e1a83241b523e962aa057078"
    sha256 cellar: :any,                 x86_64_linux:  "9f0f15affc3e83e7c74d7e79915f2d947cc5239829b9afa524328b1d3a16dae8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end
