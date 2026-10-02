class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51932",
      revision: "be3dd8e85cfce2722dd1e94c3498aa1a2719f9a0"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f645e5d66c681dfb4b78a2dc1da74681285a7365a39997379538bf293a27772"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b724e30ef3d494974959e6b7ce592679e6c6b03c23bdc9fb69c67299573cb5d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f78842fa3b23eb8c40b4ecc584c0fbc0a59fadbc4c6cacd6ce47192c8945840c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81ef59f4c622bdd1eba44689c7aaa0b55dd3045373c73ac0e4d0c333ce0f5629"
    sha256 cellar: :any,                 x86_64_linux:      "2784a819920327a13b19c854bd1ef1dd2de2954054ce493478a72442e0d2c9c3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
