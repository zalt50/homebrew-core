class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50624",
      revision: "fd463dd7de1fe40110d0e7c81aacf567b8af811c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c73b411679f171a4fe597459b3e585379892e2ff1e98142e7689b8bd682b94e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3634531a325ec141f67ed74a4cb5674960f941f584729a188b4cddacca949f40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e88b9b6db59dd4c7a74e32357a7cf387190346ed6c10c6c5dacf544a0bd1bb81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "20cbc2f7e7cd995f3e23d4e390ae4d946e3e1196a21d97d05c81231b795f1aab"
    sha256 cellar: :any,                 x86_64_linux:      "fb62c6f13d96933f4f9ae8938bad2452373859f594617fc867a29d2a84269939"
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
