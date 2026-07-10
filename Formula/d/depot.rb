class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.70.tar.gz"
  sha256 "9e5bb232409486412176003f17d5fd35e8af71d1a3ca85c66bdc3ba8306be52a"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba9acd62c0adbfe5b7806b76acfe6b7dc0805ed397ba29c187b550416b622dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9acd62c0adbfe5b7806b76acfe6b7dc0805ed397ba29c187b550416b622dd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9acd62c0adbfe5b7806b76acfe6b7dc0805ed397ba29c187b550416b622dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "14752866b3a1fddd20a4b9f8f6af8f3d70174ce7ea3701f7d2fffc62ef6bd540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c416c67cebf512d4f5575da2228a16bfb598ab4f92f1ec46018806c847145439"
    sha256 cellar: :any,                 x86_64_linux:  "c7ace6d5efd6c4c48cb43e873eb327497061a228d74e78d19fde56136053dd4c"
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
