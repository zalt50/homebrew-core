class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.77.tar.gz"
  sha256 "d95c2bd2fe9d9c8c3bcf84ddbd48288d9bf31b100eec70edd0205dc1c4258b58"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a585d76d542408344d1c9c4a47a0d6d1092570a0cd7cba4eff5c9edba98f64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4a585d76d542408344d1c9c4a47a0d6d1092570a0cd7cba4eff5c9edba98f64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4a585d76d542408344d1c9c4a47a0d6d1092570a0cd7cba4eff5c9edba98f64"
    sha256 cellar: :any_skip_relocation, sonoma:        "954581cc29fdd31d186138e398c7d5b74350972f8d40b131ef4b99e5ee175579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50dede9b1408d128086e3ec45c8ad277cc17fd4c19158a15192382acb0815b3b"
    sha256 cellar: :any,                 x86_64_linux:  "3dc3cce76bb84f4a373048dac0617c2a72557551ac345715af0838165b263349"
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
