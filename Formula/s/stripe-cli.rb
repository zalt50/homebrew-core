class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "b7ab4cb77e65dab3bdbf488e793faeab2dae03ed38ecaea287809d3305345201"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26af67f089f58425cbb074c63c0054d0a8efe0992c689e2fbdf6012a28b3a969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26af67f089f58425cbb074c63c0054d0a8efe0992c689e2fbdf6012a28b3a969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26af67f089f58425cbb074c63c0054d0a8efe0992c689e2fbdf6012a28b3a969"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12a8b0382ecc1e21c3dacad5934402d6115cf4ebc670b1d7250843e65d20c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2df8b305f02bbdb928ff94a1efff135cf2c65873efc7b5c16942f321bf0607ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c560634e8e2af197f50a002ad14d7fa7ca6541b55eb0d3f4b17cead472f124"
  end

  depends_on "go" => :build

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
