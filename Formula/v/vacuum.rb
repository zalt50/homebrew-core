class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "fc284d4c3277c0d26051122f9b524e56c8fd8f6b2a3c99ab535b3918b1985095"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "510dc36771e9cd299631f24b15b8e8bb475e4703ce73c0935b9ce95bb7245621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348beb65645606c06be3de4ca44335ede86312b427f1e487c356ca7be03dda67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd70938f9196a2ea6aab0699bfc0a09d0647ee7b850465a737833c62a20ceef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b885418ff2196dd4fc3e76c3527f33020c8f021c94e1379a5d6e74b32266f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8f8eb6f598f6b062653a95218622bd9871c2fcb46e35cc97efb37b54185ed93"
    sha256 cellar: :any,                 x86_64_linux:  "96715550273b9408d2a6c22dddbf122326b66f7770bf5364d457205630b26d00"
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
