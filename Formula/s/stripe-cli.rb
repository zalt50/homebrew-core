class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.4.tar.gz"
  sha256 "8a1c653761f1223c0d8f05b83abd39ea95d8d176e28b85407e42324aed173372"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61b6ba206a2bc6587cd6cf83f93d4dc1974269b3b0ad1951150e413cd963027a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61b6ba206a2bc6587cd6cf83f93d4dc1974269b3b0ad1951150e413cd963027a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61b6ba206a2bc6587cd6cf83f93d4dc1974269b3b0ad1951150e413cd963027a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96c8cda5907e8a3f9fc5d8915ce6099dc9b51bc98f27ef533bcfca41f01e851a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "055bff1d0a68bd0e8e5bf5508d83d0f5970a6700920aa84328e9d026525a6bba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
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
