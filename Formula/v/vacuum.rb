class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "b43d56c99a02fc1c67f8ce8455d5b6ca72ed3449442ab287ad6bd8e6523f8f97"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c056f90d38b06a9be0ea8dcef42f2b29c5a8af805db444f35ed2bec5bed02491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b6c231356e593b96ab239762d346206a476329b7b2c731f99d3e6666828e211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0927f5bd578822e1e1af5506462531beab3175c110ad3363859b2fd3d77c96e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee35bd1734463cf11466745b07709cb8ef38975f0486e451d44ba6f94dc7b9f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1f9421fa5aac68050096c2c7165fcfd55158c806d454d5be31c20cb7560b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f26b9e0896922bb198b862dc4b4e9ce9fc9861ebbaaab5b4cb9c8fab80ae1ee9"
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
