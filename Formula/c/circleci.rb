class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47876",
      revision: "4ea36161842a0cd5157c7340dd9ddec6fb2001be"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "394160c40480d264ae956c5e02826708753aba178869a2a26bff18baea3cb0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55f60875f6ebe7d37608d96ee4cf75a9f0091410700b3fe53ce4a00305cc976e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5f5b25f0b383ed0920d0f8a254803902107841095def74f617fab2e44692432"
    sha256 cellar: :any_skip_relocation, sonoma:        "07fa0fd3b9fcb8d3d6796e7c0a82069efbaf7f07df4627fd99739e2d4db3bba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d3e277c2c83e7ef7a513ecc9ca9e12f3cad4ae0566f8a07a568beb1d0a8d94"
    sha256 cellar: :any,                 x86_64_linux:  "9be221cba6b035093c38bfd981c1587b0fd8b0df7c70cf2bed9f6468258b1b32"
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
