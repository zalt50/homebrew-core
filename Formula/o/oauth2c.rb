class Oauth2c < Formula
  desc "User-friendly CLI for OAuth2"
  homepage "https://github.com/cloudentity/oauth2c"
  url "https://github.com/cloudentity/oauth2c/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "87458914b1aa1ef813f76b8a043a1d8878209042ac0285d8c27d15d304d4a37f"
  license "Apache-2.0"
  head "https://github.com/cloudentity/oauth2c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "749022dfe7dea28b09f5799eb7792bc2e5571b2fbb085a8ce972d6946002e42a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb852aae32c487c08fb06513333b27f4539d2d67ab250d01c22c17adb8be630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb852aae32c487c08fb06513333b27f4539d2d67ab250d01c22c17adb8be630"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdb852aae32c487c08fb06513333b27f4539d2d67ab250d01c22c17adb8be630"
    sha256 cellar: :any_skip_relocation, sonoma:        "975b70217cd3e9575fe3cb7c535550e206b2c350dc7ae591ee1e9b6a36f4487b"
    sha256 cellar: :any_skip_relocation, ventura:       "975b70217cd3e9575fe3cb7c535550e206b2c350dc7ae591ee1e9b6a36f4487b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c5400ef0fccf68425de4fd7559b1a635e0935f06bd28c71d3767b1bd343df56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3948da012d3d9ed55544664df1d8b3ac9e10919860128b2ba359c878f9850180"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit= -X main.version=#{version} -X main.date=#{time.iso8601}"

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oauth2c", "completion")
  end

  test do
    assert_match "\"access_token\":",
      shell_output("#{bin}/oauth2c https://oauth2c.us.authz.cloudentity.io/oauth2c/demo " \
                   "--client-id cauktionbud6q8ftlqq0 " \
                   "--client-secret HCwQ5uuUWBRHd04ivjX5Kl0Rz8zxMOekeLtqzki0GPc " \
                   "--grant-type client_credentials " \
                   "--auth-method client_secret_basic " \
                   "--scopes introspect_tokens,revoke_tokens")
  end
end
