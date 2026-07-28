class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "f16b53912eb32d94164032d391a52ea3f847334df25985121d6a53162d4c6a0f"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0928ea0d8818bb79754bc65fd422dcffa34f068ddfb3ff80e992c261cf59837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ad0394a09f20c873a5893a0382e9c3ebff8f0e18c33ae35086d48ac065e421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d11fddf58bf791deba7ad3a78234f79903d743e16b4f02932535189524454640"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6bb13efd350876a49cfb5c158285a2fd517ca0747827a3d362b024451385cf0"
    sha256 cellar: :any,                 arm64_linux:   "c54d22728bb0c78e586f4962e912422db375b70ddbf348b6ee2430b3a415bc9d"
    sha256 cellar: :any,                 x86_64_linux:  "667dd2190f6eb25189ffe6c001cd396ff76fc3467615d670c01d95f28f671d2c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
