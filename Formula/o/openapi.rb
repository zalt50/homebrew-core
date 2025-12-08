class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "c72532301a8167480ed370032d9717b789d671897e2217465ce9850f14c913bb"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b61686ce97c7e55743b383c0d75fcdb9b98f2c63fe6b0462f45f84d46e6a549a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61686ce97c7e55743b383c0d75fcdb9b98f2c63fe6b0462f45f84d46e6a549a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b61686ce97c7e55743b383c0d75fcdb9b98f2c63fe6b0462f45f84d46e6a549a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5666eb5beed7ab8cb7aaecee45df8262912e7a57b57c9ca148ad6de4f01587ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af19ec4d4c5d07870e032257d5ae156b458589e66b9435b69b581b6cb9af2d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be8c4ae151c87731f47306c9e745705a72423c00e82b7f4941c09c2d100bd20"
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

    generate_completions_from_executable(bin/"openapi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
