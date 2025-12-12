class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "92b99141f5fcfc072ff5622d68351d8e7fc067175925ef3b165345c16d5e2b40"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac3f4f161e47053bdff94daf6aca5f2b5723747b9a59e0ddb0b8f2d587afa548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac3f4f161e47053bdff94daf6aca5f2b5723747b9a59e0ddb0b8f2d587afa548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac3f4f161e47053bdff94daf6aca5f2b5723747b9a59e0ddb0b8f2d587afa548"
    sha256 cellar: :any_skip_relocation, sonoma:        "f32eec5f2418da752255542545ce770a3f38cf2ec24ef9a9d4b75476a278f008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2b298ca5eb6fa0063b5d47b760e51b19b002cc854536878e6e99c92e2e181da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04583e265a1934344c2f5f88e7f90e5a655aa5aa9644b6c45628242d7535c9de"
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
