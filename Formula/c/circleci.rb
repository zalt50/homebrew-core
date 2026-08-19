class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48658",
      revision: "e6a42155d60857bca821ea3037535f69a2da52ac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd137ff3d3189145f13aff81c965b290556d380aed528408e84a53855633a9d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbea039ae537950530f77269caa11f91395606e90bd222c186a4d2b8c95a21d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b1f03bcb16f732584c58c19e0ed3901b2aa8a710d6ffa8df5dc643e27bb494"
    sha256 cellar: :any_skip_relocation, sonoma:        "99139d4eeef0703e8de58285b6210e646c52986ea6bd3d823a669089713eaa59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98fbc2dfb7b1384ea94405034df7a2b9bc2bb25a99aa1b0cae7bf796abf118cc"
    sha256 cellar: :any,                 x86_64_linux:  "63c4eda91abd089aa54765a58d7d76dd4cc1320fc59d826f30d0a16f58067674"
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
