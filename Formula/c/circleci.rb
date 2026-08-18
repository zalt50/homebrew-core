class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48490",
      revision: "29450bd6f6eb821d03982434beeda9910e8da511"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3015e6da305da539cb39af3e95738f023ec16ce51fe6b23e3b451194795a8b17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c634d5f894cadae184088d77039f1d932d43ec07072467e6c22df1f8f288fd15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d42a9c47b2381fe0ac870e347ddcfd388f818c5cea5b4948a711c4cf527d0bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d53959874f3aca9d5361006e7ddc132a73796d292c0b127af2079f8624ef5e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bdab78d1a7929bf52eac0526d85e4b78f78a0edfada32acc4db6b7789c8697e"
    sha256 cellar: :any,                 x86_64_linux:  "f2a335b2a48d1e1a89b6ea36dd20c6d6bf60138e328894224e520319348e2739"
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
