class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.5.tar.gz"
  sha256 "52bb0cb688f964265141b0135d61e58b71482b61bf67bf28c57c98713d511def"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f206addcadbc3d5b11cdd575e156ec13b731a4c26b3d9c7086e8fb645c02b1aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241afac8cfe5bc7b64959a98efa4c0a00c8fb8abb67ef4ece1dba8997b6b7afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a60ea352720aedecc7b9c2424abb34e9880104c78a652c34ed6bca20c99bd7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d797f443dc8cf4f635641e7e41269291fce032e466038a8b9f2986014656a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c037b6ebcddf11c475c2388daef44bf781219adf41b11cfe25f07251d701477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3716688f785cabfd63009f837e0fa02d3c143f73dd658bcf6defe58dcfc6c676"
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
