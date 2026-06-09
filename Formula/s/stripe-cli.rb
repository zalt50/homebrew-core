class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.5.tar.gz"
  sha256 "52bb0cb688f964265141b0135d61e58b71482b61bf67bf28c57c98713d511def"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "563f754dd66df74f7caef7b7f3ab79f198e3250405d4333823971623248fb8fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5feca28a18ff972afc75ee71f9e82555f95fd77bac63369a4a939d7e29bf9f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107f38a41ba18a097be820ebafa8902160587578ba9ccc9218e9e144557fd3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ef4a07cffc02709373a32a762ea5ad37229bdf1f9550193e5744ba5471fe4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "327d0459a5ca46500b85a6365fde395f17ef763e77041270456b1c07a18c221a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89fee2271ab8863e3a285c88f92cb06888a8f39cd23e9301b3510b5d1c723dd4"
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
