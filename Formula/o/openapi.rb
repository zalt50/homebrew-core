class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "bbf8e22f94a4d28117f34f2bc92761c9c36016c23b47dee744e71d61a6e9eb6e"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "072a65e464cefa7682f4d56af88d8b272cae7622c1579ddb53efb5d53fa92c2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072a65e464cefa7682f4d56af88d8b272cae7622c1579ddb53efb5d53fa92c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072a65e464cefa7682f4d56af88d8b272cae7622c1579ddb53efb5d53fa92c2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1d77cf3253b6242f369fe5ab9438631b137651c3cb9de6dde2b87bedf3f7d23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b71a5e0bdaed3cca170d4d641282d29a6050e57e3ee8c665aa7f96fe1a3933a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ce1e2cec5df9ce7d852cf32548cd2b5e7b0b6e2202421659a1da9d12bd5604f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
