class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.2.tar.gz"
  sha256 "d89003b6257ff9dcb4940fa98c8f63dea504451853f833872d5f61d65580cf9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1862e8bb90a0815ac3431a640d6623fd4f708a48b61cc6c0c28734685284ad48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1862e8bb90a0815ac3431a640d6623fd4f708a48b61cc6c0c28734685284ad48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1862e8bb90a0815ac3431a640d6623fd4f708a48b61cc6c0c28734685284ad48"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f234e8ff13d016c06f72b2042e94549ee6c36091e7637dc42e8224f0a16e177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "712b3619207c39561991a29e3000940f0e10f082a4e65711466d5d093527cd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de9858160191e5fd56fcf4b2e0cb4ee5f55df267b2e9d5ff7576efff726830f"
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
