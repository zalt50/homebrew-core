class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.5.tar.gz"
  sha256 "841996596089c3bba24917cf1716552c98fd46085fb5c5719abc037ff22ffbd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6035fd14dd111a1382974829abf9c7ea2a257b4e679a10ccd9c0d374ae006ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6035fd14dd111a1382974829abf9c7ea2a257b4e679a10ccd9c0d374ae006ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6035fd14dd111a1382974829abf9c7ea2a257b4e679a10ccd9c0d374ae006ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0dc2226d611420cf2704a5d07201c388376855054f57574508110bd86abca41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2259bad1abde266c0f99f6ef5aece49d5d4083a9081bdc4c202366d3f66f57d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552d34bae2c04865d3fec0e13a93dab7fa29b1d00f11c65adcba66f63756b4e5"
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
