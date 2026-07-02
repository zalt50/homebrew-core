class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.29.9.tar.gz"
  sha256 "c6becf62f8eca4bf46bf2b38dad055e7c9cc7461d8578cfe3daa4a5304a16d2f"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e8a5503308b978da01ea30030eb60bd356cf040a7c1160a2b8066b47cde6d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94414d18a42fa28661ac1e30e580203a3c073c892b378b56127b3dbf7e845a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9781b243a777fb36ecde458aba4aaa1e64bae37d34dda0fa4990823f3e5f21af"
    sha256 cellar: :any_skip_relocation, sonoma:        "9640f97abce0de101f4d0e93521ded3cf59e819cdd1bfa162770122824328ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68d8c6811f114ea767e27352d35e78e8985cef22e261278cf1fb781bba046acc"
    sha256 cellar: :any,                 x86_64_linux:  "f90dcd62dfb8bb7d20a5f411eccc46a2d140828161096d737e1cde8e5be53c9f"
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
