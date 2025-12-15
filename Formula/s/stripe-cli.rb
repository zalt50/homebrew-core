class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "c2cb22302e41669538f08e20e33f3ad6fc6e247d60695f390d42157262389a45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551f632e7672e4028f25c78eaeafb8b42dbf734b086250988dacf761ee294248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6c74a02ab86e19f0b2cfe45e12b9f78c48006bc8635045c53f8441e41b82f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0cab61bfefb1bdb8808f75b32468d6b1974525cafb42dd62c70e2cbe9e6ff72"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb0d851951bd9b7c452ff37d6c370441bc9a21a3bf2cab1bba89dc2e31d7de27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0dcd5a20a4cdd8fa507596f7272365fceb31f15de567a1cf7f40339907feae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e6e828c1e032b7b0d5568d19ace6aa139b349ac22c4317da589b6abef28af6"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/de62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end
