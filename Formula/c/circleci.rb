class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47692",
      revision: "e05a7e5cc8fc4d2286a6804271ddd2a155d7af86"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "681662894c8b4843f19be5272b8d6515b17aad304110c1d3a7332c9d690a315d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aae877cc51d473c7229f1cfdad6ae711182725381c814ea010f0875176014d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9936a2d432b3b236c87b81a8d1318845d47ec6e89882870061d5864915e7f5db"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c1d8914691b506c65fb4ed0f538d85bb1970ef6eb93f1e61594b1b918007805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "956ba97bec265c59624f2453e0e27185f9f19153bd3c0eb9c8327c871de28f46"
    sha256 cellar: :any,                 x86_64_linux:  "c537ae34235db3f240e72048c36190f65e1251fd87a790c38c6e44f82922f9f5"
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
