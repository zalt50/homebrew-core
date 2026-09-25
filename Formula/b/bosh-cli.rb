class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.12.tar.gz"
  sha256 "2f2fc3ae2f228048b771811cbd8725028ed266db2d4a420c5fe51f1e86c365be"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "289663aed3ad2318eb5947a09cd7167659885107db8895e59e2f1e4bee442d15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "289663aed3ad2318eb5947a09cd7167659885107db8895e59e2f1e4bee442d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "289663aed3ad2318eb5947a09cd7167659885107db8895e59e2f1e4bee442d15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15787b08dca3c656cf77eeec2e9bca63072c01bef7f16f31c94e5478a15cea1b"
    sha256 cellar: :any,                 x86_64_linux:      "04c90bf31bbe7d78daa8ee81217df50b101a278c2f90d2398c33facd6af89e2e"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
