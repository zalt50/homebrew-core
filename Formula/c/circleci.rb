class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48122",
      revision: "a00439e32dcf321e977e07d36a3b681ce2ad6539"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "683d1682e858c8a1ef6ef107784ff8843b84b65e6d5a90d80fe5974bda1ce0d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "389050ec6e4384845d8d66f8d2377008399f7b4a2dbb6f3ddb7e255674154032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e318d57ab385856371178dfb7ecd059e872c2d16df80e640f8bd5851f4be26e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e93d7904a68da6cd092740cbe6627b205763fb622849425a25338b4984814a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdacdc7f78878903b1a72d88f2aa36f7d45b3319c47562c541edb2c872a29dcd"
    sha256 cellar: :any,                 x86_64_linux:  "3027624920c2923a263b7da5aec82173325153338492b8f333943f2e6dbbc769"
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
