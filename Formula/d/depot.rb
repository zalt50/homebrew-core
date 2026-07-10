class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.71.tar.gz"
  sha256 "b327d1f4a9ad277b3f9dfdef189e84e613ac3e8cb8c2e86ce4bd0f07ba078961"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27666b690fb8b1671e4b113a40240e281d875345b2232dba8c59805161c615c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27666b690fb8b1671e4b113a40240e281d875345b2232dba8c59805161c615c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27666b690fb8b1671e4b113a40240e281d875345b2232dba8c59805161c615c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14ffedefc85c752a9164182fb02a906e54e5f1402d4864b9d5d2118ca8c500f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e1e0f84d803087312dc3ffcaafdf40033ccba16e89b84dde37e374875283484"
    sha256 cellar: :any,                 x86_64_linux:  "9f1b4158e816c00187b70f5b18858fc4527e40f666b6dcfde05b78f5630a382e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
