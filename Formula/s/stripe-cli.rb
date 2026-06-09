class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.6.tar.gz"
  sha256 "e0214f2fc72a792c357dc4bea4358eda672622424c5b5db5c72ab1116fd58f4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7189aa7a4bc0adc93f01ec54c98342d802cbaa010975e09a8362d437b7c80cce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3760d3377ec90e58fa62f79c2ebb5e272566693c168c3267ebbc276bcf9de3f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "384eec2a1ca7a93d77d17d6ba4b3351d58e36cc02e2eefc3b064cfab2626db10"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4cf30c47e88cd39de5485480bd5180d394961c32057709d8e8535c45437813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7fa183d09631013151dbae3ee05c4ed7d2cc11384cad57f2aa3ae4375fe82ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1694564a7250be883a75d4c0c5a25d7b4697e71ab70a9e8eddd75bc135334a"
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
