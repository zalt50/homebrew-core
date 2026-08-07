class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47401",
      revision: "1775afd679ce8abba4cd4352ffd453f2a7f29f8f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923466c74f0ce57462d555d5852fb3895934e4eca8011154c584304c1af1f650"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58104eea962c4147eae69365ff4873131fe58f4d4eef416f3711a3ae352616f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c95cb7e3d3eabf9f23b687698febc93bce6ff52af637cafa4aea0817da17fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b1e8c94ec93b2e98aff4b3291ac411614a092018ace817f3d053cec76f91bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f33298330a1993b7507f69cd9d6f6d7c68eab4b1c1ed128f72cbe3abad0e70"
    sha256 cellar: :any,                 x86_64_linux:  "b94c84f5e4d35c6de904d69e5e7ab7b9626e4ad887d2bf644fbbb1ab54130ece"
  end

  depends_on "go" => :build

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
