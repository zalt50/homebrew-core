class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47471",
      revision: "c82f24c3bf8c5a01da7d5fd03f7b897aaa19e337"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0200fce740bb9bc1d67c62c315a2a52ef610af3cacc826a8fbfbdeceb1525e0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31178b6574aa7b53abaeb45004c07de0ebb882c0321836e0d44e5d80d408c370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efc228209b3951b5b9b6fd279829e323d60dd2249932001c223baba4ee3c4b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "b557a9db0426cca0971901b5dcdd4ef2a1fe517830cc6e963d402573fdaf0b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d118fbe050288e6d0e1c5fb5111cf28a02b130cb833847bcb52267d96a6a7018"
    sha256 cellar: :any,                 x86_64_linux:  "274162005677ce03b1ed29cff8a111400277673dbae447c2f6f023fbf084c5c8"
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
