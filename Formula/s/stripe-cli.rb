class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.3.tar.gz"
  sha256 "d14e4caa0691743facd364e05e763ea967db2917f72e2cc24b5421f769403928"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1fd24afe3f5b53416dca9d1d39d6a874cce8905b5f97d8528f4fd76ddb714e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fd24afe3f5b53416dca9d1d39d6a874cce8905b5f97d8528f4fd76ddb714e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fd24afe3f5b53416dca9d1d39d6a874cce8905b5f97d8528f4fd76ddb714e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "12a824001607a031e7a26581e5c157ada59990d2a5be56dd73628e7794c8cdfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0bc8d707da329a34b2af90dde093db151ea74984cd96e7820baf2447771532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2357d90bec34b2b83468d10a17f654fb09ea9f97285425d9db25e1a35b901c5"
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
