class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.120.tar.gz"
  sha256 "7c2fd91a5a866aab841e57c36e1541a89452a38c273b30ab918e802c83ea37cd"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cac83324c2adc9ebdfe818e5db092d8d1d56eb8cd8827005bcd9afecb8e6e8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cac83324c2adc9ebdfe818e5db092d8d1d56eb8cd8827005bcd9afecb8e6e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cac83324c2adc9ebdfe818e5db092d8d1d56eb8cd8827005bcd9afecb8e6e8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "31582ea071eed8e28209e9d087e8fa0639bae841a6e20b4f7d9099add140629d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf687a533cf6a00c6936e5d0fff00be1126cdaceba783799f85a1c47a0e3beaf"
    sha256 cellar: :any,                 x86_64_linux:  "3790b40440bd1be96dcde5019a176ea04f4177021531be43940f2830dd221f75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
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
