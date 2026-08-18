class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48365",
      revision: "099beb5c97f27cc092863e7945b91a8e0e514c8e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa57adead5d1b13f5fc1c65b3c66c712685b2aa77f01c7b05d08582d91a16e9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaba999b9c32fb46b7da66033bd108937d5cf2b2afd94d56d88d5dad5d3e336e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37f346f435f91f0b6fde4a6701586bb8b781dac739b4029c5965a8657384ab19"
    sha256 cellar: :any_skip_relocation, sonoma:        "560cd4bac389ce0dc31952d42abf5e111e3ed1360f5f739754ab8217bf065588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f67049ec942f0ab02f8669bc3869454e6fa855b1ae6c917ab414160a49adf069"
    sha256 cellar: :any,                 x86_64_linux:  "1029a5ae2e038f5d5174c8db5eef9e3d0d2a665a40b493373318bbd25f4fd3df"
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
