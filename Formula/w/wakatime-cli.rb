class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.20.3",
      revision: "d751b41019ff8abfe7218538baa8cb8959ea4338"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27ddd077d4a6c65fcbd118e62f7b7eb5a042e4c679c6efd35fda772d5f7788e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ddd077d4a6c65fcbd118e62f7b7eb5a042e4c679c6efd35fda772d5f7788e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ddd077d4a6c65fcbd118e62f7b7eb5a042e4c679c6efd35fda772d5f7788e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d56783a9fc75335260fa39c93e7e2277249113f99f79a3b831ebdd1b88b68af4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5b224c916b9ab97e956c47a5d50381dc098940f9f87dca99e4034f1180c1146"
    sha256 cellar: :any,                 x86_64_linux:  "9533af8eeeea70e498becc0058ee063969562e6ec020c3ceaf4cec02c6d75703"
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
