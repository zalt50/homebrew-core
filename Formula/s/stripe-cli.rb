class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.12.tar.gz"
  sha256 "5cab9451038c92050101f9dc57de9f5f15129f0d6cfdd836fd9775b7cc53c69c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4e7007cd5f172f70f0e0a7540962296e5a4c9ef578768bfb4aa01f105d509e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12125ed872a1eeff437470ff64320e4834d16858ab2f1bb8671a423176461afb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7596e3f2b17e462b52b787f6c483accb00a6ac6ec685e5c1698158107139767c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f57c1e0a64daf32cc3003d4416d640441e1529a1ee9c4c3745c6e2d8c65cb35a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3a352c6bb397d638a3a2d1256aee39b22aeddea6a20587e73d97aa1a3b540fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d6173b230bcb0bb86c68db6463ad68cdcf1433e5dcdf3e6721814440c759e6"
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
