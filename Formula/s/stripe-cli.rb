class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.10.tar.gz"
  sha256 "457d7bc76dec2cce2d284ecdead7f10c8e9397316b3c0840b089855988a65e7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd9038d9f46cc4526800a806f9bee026d18fa0f3b0e7486eb238d908673a682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619f95b49754ab31c70413db89d933b4d717d93f4561bcc780d8c241d61dd9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acf19d1fd037d83d18a37b7adb63a7b4bbbe284c6a3bdb9e36e5b156cd735464"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5c89cd86182013403cd40ab7a6df67504c63a4aa00cfce8e8d765f761f7c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aceb5a0482795bb65543f24274340e12951a046cecd3a1acc380d04b3fd00538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "044098f5577bc6ea3ab7afe71c0163964b6124e8465d578ca834a90fa95e9cb4"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end
