class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47091",
      revision: "66186e495abd408f2e9f0022d27b64793bfb783b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb3e694faef9765aa501db93fc9f79c33e23c6346953e654d5a5611bed14f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabe087a59efaa6b88f75bf8f7158d2fa05327f2421e16486f29bfc831cd3c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e238c92f0ab868e30324b1b7bdf679b7e17e5511c1f7bc460881322c0401e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaabe54c56eb5dd6219b62da993e691866748772b728981708df3d523921280d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94aeb7dd1028b40df92721aa135eaf4f402fa130b8218f66332392745d9e076b"
    sha256 cellar: :any,                 x86_64_linux:  "55682cb6177b7dfcb1bff551f8ae52385b2b7ec908235199b60d858d0ad0a0c8"
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
