class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "f17bca1cd74d14eee9fd80444eee8088a0e1ccb53b2b7359efb4906af3830b68"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "517529585e5e719131a90253653c1c7ea72cf799652f2a99faf70a2728c16fbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "839aa6b9f186c4d15f69c9729e55f4be4427ba089f552d7d93b2341120f68e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37acd4e6b52160e48979ebcefcca82001395ce2ba6f83eef71e69c4b6bb053ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9806694a9e7f338ba82ee4834172ebdd9262b4eae372ad2a7ef0e527bd0e662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9eb5da6a85aa42619bbe0d3731276fde83daa3fc45ba920a3c1ac19885c56f"
    sha256 cellar: :any,                 x86_64_linux:  "444ae0457126a19a7400e1405cfa9f4746ce89afb81f4f8f7ebd0a901abe934a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, tags: "html_report_ui")

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output

    output = shell_output("#{bin}/vacuum html-report 2>&1", 2)
    assert_match "please supply an OpenAPI", output
    assert_match "generate an HTML Report", output
    refute_match "html-report support is not included in this build", output
  end
end
