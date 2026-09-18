class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50735",
      revision: "505f892cd3a8da7a31f3e822a75277d73a310df9"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3437654117a670b42bbc6eb669a83e20f56c406d40a1d48ee90f4b71a6fa5bcd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a386810f3aec4f614779a2f3bb9e14fef0bb394b9236667bec6eea5280985735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "14c7f750937f983d45c6d28123759c4760f4f2caf5552726bdb8dac62b5ca62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04b7c9b87a8ed3339adebbb12136ae7e169a9d7fe7f7035643d7ad84b0bf1b26"
    sha256 cellar: :any,                 x86_64_linux:      "8c815f283553da9f6322061f4931d2248951a1be464b246e51b434b9c06027e1"
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
