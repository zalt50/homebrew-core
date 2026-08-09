class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.24.1",
      revision: "80af9893563708d7f159a4677fe38835e1c42eb1"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e0497e4e54672e4217847a8838c8d0c70874ed0f5a9f1fd6f14fd7d457c26a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0497e4e54672e4217847a8838c8d0c70874ed0f5a9f1fd6f14fd7d457c26a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0497e4e54672e4217847a8838c8d0c70874ed0f5a9f1fd6f14fd7d457c26a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "38526ca9d6c8f847868b119f4c63c7edc936cf0505ca62b50314e539c201aad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c35d776db2797822012b8f63a6c4f4018fa9cae488ea36bac25780365237f849"
    sha256 cellar: :any,                 x86_64_linux:  "d41ea02765e4b5b3b12e2f7d7c92d7b07652fbd3b19a966e7e8a1339dd20f91f"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
