class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "c881be645a6295a6a5bb7d85e5d45f9f157d810c82d7c0a230072b1ab8df7b6a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f2deb1535fde829e0114c99132f5a395dba5b02a1eb5d7b7b232f0761d726ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f2deb1535fde829e0114c99132f5a395dba5b02a1eb5d7b7b232f0761d726ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f2deb1535fde829e0114c99132f5a395dba5b02a1eb5d7b7b232f0761d726ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8093e41f5dcfbdfb1c2ecd8a771a97595fad760ded923a8d7db1e94672a51f7d"
    sha256 cellar: :any,                 x86_64_linux:      "7b48eb531f99e19e5916030c0578cac9827606d9fd7ea81e848d8b5934e317c9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
