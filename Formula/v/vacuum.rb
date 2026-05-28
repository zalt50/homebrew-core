class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "17cbf2426dd1954c2ef7352182cb485727997e453db3555786c170f2bda47c38"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e547b59e74f20ff29315b0b0da5f0c6a884be039a172a564fc7a84a3515cbfb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406081501742f7c2badca03d30e494d59081666c99daf54716d2fe21f1dabed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e856c1578ba95af2121a9b1d6c5f64b6113a0716e2edb475dd820a7e7a54a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "df378a705bfd44b3f215538290297d40d95e9e00d21a1a4d72513d3af3332159"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56702ee5e50919a11f4e1484df7ca3a84034ede8037bc29a299e471fb37de985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c646c1f657110e259913507af2eff3352992aefd7b0faebfb5bf196a5255c428"
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
