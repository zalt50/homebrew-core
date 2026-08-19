class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48633",
      revision: "15fbd16a47a929adf9913fded4388479476250d0"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b9cd0af438976d546942a747f42a7fbcba4d699c7b5b789a14c2c3d612115a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfd6f61cee4ea3702427859ac09fd40dd706c92226b5a54d4fbbd71b09789a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af4e4abf290f14e752cfa74b696cb2a00e0c51cbf6bbedda18846ccad205e4b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c1ad473dbb84ca415b003e33c27f8c4c1834e4897e34c150e6056ea60f94a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be769640b5e3e78d46aa22110e472fa25efc884d83c404c29b542b4adf292b40"
    sha256 cellar: :any,                 x86_64_linux:  "400d71b4eea5dd5de706d0ab92d0dac3a3f2a5af8170f0b6e42f7a3755118b1c"
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
