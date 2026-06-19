class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.19.1",
      revision: "5fd5a2f27d2e617a7fe0b571e7c7a65b773c9517"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f29d61c11beed1f9a790faae3668de53b7cb5751c30e8dfbc57b3bfe98fe0b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f29d61c11beed1f9a790faae3668de53b7cb5751c30e8dfbc57b3bfe98fe0b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29d61c11beed1f9a790faae3668de53b7cb5751c30e8dfbc57b3bfe98fe0b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "086610be9fda264a6e5e0c6b62c891549b7c18d4593f06ec73c89b066ff8adcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "440960f774a4eac9505fb59721c8a689c00159c7cc4e886dcbc5026187a8db02"
    sha256 cellar: :any,                 x86_64_linux:  "691b248e84ec8d4ca3e905df4be8e294b42bf251f1feeda292e5b9fdea931469"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
