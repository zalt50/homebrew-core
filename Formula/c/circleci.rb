class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51589",
      revision: "f217d07b2568553742c3ab7af126f60186c86736"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d5c3e21257017a01a85290bd319da147414e9fae85e5c58a9630523ac140d69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30134f7f2fe7c6c061faa294c9c2b0756152aa29e863dc10fe0f616ba86c4d1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e3e79befff8e90dc721744aa280fac0f8f36cf8c41924dd7695aa6e203f78c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02c6ee2f5700a75f8708bf6b00ea0bac3954fc031ec1542e43f5e1755094c419"
    sha256 cellar: :any,                 x86_64_linux:      "f228daf62cb12bb2ee383b22c8ad7e9ada26feeb8dd329f2fe70a89704d69986"
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
