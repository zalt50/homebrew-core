class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/rest-sh/restish/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "28bb590d518c17ff51f6c07ad3cbbd417fb22a2cdbe122052f16b95cac652121"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d63ff85c5e611b77cdcf330368744bbda2453a58c439b59204768ea0ddae8ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d63ff85c5e611b77cdcf330368744bbda2453a58c439b59204768ea0ddae8ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d63ff85c5e611b77cdcf330368744bbda2453a58c439b59204768ea0ddae8ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af0c57523b0d22faa372c82d757b75a921cdbcbae2d3a9e091b76fd17f87bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16dcac7c22ad5138215079cdcc8f3cedc1192e2980cafd6d5a1d82147abb0f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040092fedbbbeb4dbe5c7bbe818b7bdc03ccfe2b7ba32612393cb632c2bbf8f3"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for crypto11)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X github.com/rest-sh/restish/v2/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/restish"

    generate_completions_from_executable(bin/"restish", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match '"foo": "bar"', output
  end
end
