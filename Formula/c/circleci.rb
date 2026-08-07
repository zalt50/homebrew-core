class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47244",
      revision: "a6b9f54ef9732053e10f676488867862a6f019b8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba58b4a70b433a8324b383ab6c22bd1a4dc58f8b92a4a5cf7c891a33b5895867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fcdeeb296b07f725078cb95b3953a5b9e4592417689fdd2ab30451197dc76c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b9cc79725a4eb26fff61e9e555039532c3464b112eff822695d1c8ddb1f119"
    sha256 cellar: :any_skip_relocation, sonoma:        "a45deb815733be6b494e91d38b83222c39b9c7911c01ce907423d994d171742f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59ddfc0d353bbb3bdcc9d5d8252e0d7f26e4c15c5b0e9328317584fdcd3d0d5d"
    sha256 cellar: :any,                 x86_64_linux:  "69967054536f85acb91abe926c0752cfee5de3165c0821f9b29baa1f877c706e"
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
