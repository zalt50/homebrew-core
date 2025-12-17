class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "b595ad18d1463a61f56e5452129c1becf900a12b1f8fa789b453afa64c473726"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0570b4f6098f3a53bda374a74460676b3adc136630d00e2b4d5408e3220255d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0570b4f6098f3a53bda374a74460676b3adc136630d00e2b4d5408e3220255d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0570b4f6098f3a53bda374a74460676b3adc136630d00e2b4d5408e3220255d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f138d522c04083f79a66c1eb8c45b568e31e7401471986217d2355d21f68a141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf2277d8203d8f6ddb2e485ea94747674ca0d4ac0bf74121de1f1f102de0df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7347697032140a34bb47eb9d33a06989565c49da56f3fd2c7eff123293aae34"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
