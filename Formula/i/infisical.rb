class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.105.tar.gz"
  sha256 "60b902ca072ef072f97399b71204175c49cd08b5ae41c611629f982b51d0fc3b"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2f0bf69c30f769e8a6464c27c7966f394e2baac625af0279267370b01d0ce9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2f0bf69c30f769e8a6464c27c7966f394e2baac625af0279267370b01d0ce9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f0bf69c30f769e8a6464c27c7966f394e2baac625af0279267370b01d0ce9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a097ff950b66880e72dbae2c89bac07d02d7f82415153c58ccc3fd9739698ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7736cd78e607568b5f36374451e76fd678af5ea4a4c572788cccd83dee369f1e"
    sha256 cellar: :any,                 x86_64_linux:  "03c61bdf690f314d72311f51df15a55b6cac5effd96fab2c964105c5b53f3a43"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
