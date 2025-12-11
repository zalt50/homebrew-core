class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "a156010deb588964b7292c3d1d0d8a410a6634cd349338514e1751233ff5e66e"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9add64f3e63e9649f81ba8117c3e70f0f833c788ea6470e6e93a937b2a6989e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9add64f3e63e9649f81ba8117c3e70f0f833c788ea6470e6e93a937b2a6989e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9add64f3e63e9649f81ba8117c3e70f0f833c788ea6470e6e93a937b2a6989e"
    sha256 cellar: :any_skip_relocation, sonoma:        "55e5adf4dea6e7939a6e02ff4a7ff3ee22c7050918660549b932439831256a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411875e8721e5282596c0a278e19917023e50d5768051c3ad4b397b35f586ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28b69d122562a3f0c674b5d88716ac05e899e38d95cefa487d286081e78fb83"
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
