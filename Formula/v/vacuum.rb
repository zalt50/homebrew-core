class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "fc284d4c3277c0d26051122f9b524e56c8fd8f6b2a3c99ab535b3918b1985095"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55c2b8674b75c535ff614574f1be89694e09f40a488edb634319ad36e81cbed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b39133d628ebae08014261db4b7bfae0360bed8b3a96d3b73882f1cbc11de0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae52a22ba9cbea7bcde80b422cfc5131f52d9e172e64dfa92051cb88ee5b64a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3a3c470450b4659eec020a4f7ecd32f1167ba6a1044c87ec8bdd058d223b3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc30188f12133645cef4537e70c4c58233e6f5e82223b64a534b4c1d017c8f21"
    sha256 cellar: :any,                 x86_64_linux:  "a93376ccaadfa11cb6047e641e8c4e249c2f64ea2210eba4b643a00994e29c76"
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
    system "go", "build", *std_go_args(ldflags:)

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
  end
end
