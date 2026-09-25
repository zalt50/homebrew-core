class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.12.tar.gz"
  sha256 "2f2fc3ae2f228048b771811cbd8725028ed266db2d4a420c5fe51f1e86c365be"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da589d3e3fd58e50f48b7909f035b4f3b405fd8d82a8e00f39cb24e59dabe812"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da589d3e3fd58e50f48b7909f035b4f3b405fd8d82a8e00f39cb24e59dabe812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da589d3e3fd58e50f48b7909f035b4f3b405fd8d82a8e00f39cb24e59dabe812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "da589d3e3fd58e50f48b7909f035b4f3b405fd8d82a8e00f39cb24e59dabe812"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aedd410b9a9e0c8abedc3a821fcf59496f12999f8e17a6233ad1aad83d91b3a2"
    sha256 cellar: :any,                 x86_64_linux:      "25475c018efe68f5d0bf047b21967930720f63d59eabb19fb2ee4fb1aad978ca"
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
