class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.28.4.tar.gz"
  sha256 "669efe71e06bc8e59f293d3e015f96aa5d55aa28b59bcc960b6925592ab92511"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a80dda270c522ac0b91ca25641cf3a9602050251150bc17ab535d8aaee6dc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89cae55b1e7e37c965177ae63dde45400f1c54da83b5d102e98202de5bc9c9dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e46bdc4f909a0f5c06223cb65198080e07e12de59feb13e9459fcca0878edfd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "af3f1cbdb5f41e20d895677b6513a60415c30505045a9960fbd0a4882edae81f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4fcf77e240930105c3e8252bfc229853fb670cb0b95f3928e7f9e7d5b5d0ade"
    sha256 cellar: :any,                 x86_64_linux:  "b1396c9258e5c33498f228d1707941da4448ceaef6932d86edcbf48298f8a43f"
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
