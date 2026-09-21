class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50831",
      revision: "d6b7cdf51ba4683a102e485c93d3e6e64c821b54"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f75fa767695ffeee69ec2d73e9a6d38c02f3a810c8aaf5a8269b2434e8998f3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d6ed42a1943b9dc8ff31d51138256c32d8fceba326fcced39d99f0d7e516fe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "242bb30997b5c746202bcc5a55247130a8d72bfebe9f6b934aae36b95a676508"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7fe915969e410443bb631cd6612f0e12d64d64c5a74ae20ac884ef8504a882f5"
    sha256 cellar: :any,                 x86_64_linux:      "f83bc01b270ff73bf52b95b3b4ec588b8fb09b6c3fd84a3ae7c8900e0f744f13"
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
