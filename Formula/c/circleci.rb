class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50365",
      revision: "c4ab549f7dc992db89ace59eb3d5bfcf823ca107"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82991d2a2eff890efcfdacdbfbfed6081791cfafa0e07ca01eb2e39758f0b4f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc2f93a93a664390f2f69d80a83f03f508248848816195f104cd0ae21a9c09c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f091af4356a12155f16aa9f6d85ec2fd487154fb538f27174d856aa97130375c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96f013594e980d4a6d745a40ee83efd6d82295052ba2f9c91a42c8d79631ef73"
    sha256 cellar: :any,                 x86_64_linux:      "0b841909b552dc6f936fd733371f79feaa355192aa0b039c793c62cf05a4061f"
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
