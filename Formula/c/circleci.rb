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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd6aa9216bfaae903f6ac6db8945f225a2f7f7c40100398c48d3277dfe651aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba427da67fbce513641f14b5439ca561d5c4655a03e9c9d912f9c34ca7adb970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241d656fcd8876b502e43c9c82bb19437136d7b2e4d7ffbdd25aa0bb6c0ac8dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "80757043941b049be5ab50b7fe9c40c3bb124cf992b1d06dc16fcac1fd74764f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10da8908b0a66192c416e2fa633d5b6fd9c00ebcb7c6ddadba95168b45bf5585"
    sha256 cellar: :any,                 x86_64_linux:  "a1bbdf6923a472009710dd84e48d92f4d625c762d543de92675e24b5d0366fcf"
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
