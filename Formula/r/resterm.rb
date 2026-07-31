class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "03ee8f4ca9677a1133f2f40854374955c8b7a4be880d1a6b586e584c48e6f2d3"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae24297fbb5e83d03228580c92593507b1d583e00cf64070d811e26b53f85492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae24297fbb5e83d03228580c92593507b1d583e00cf64070d811e26b53f85492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae24297fbb5e83d03228580c92593507b1d583e00cf64070d811e26b53f85492"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b2b63f77e72ed51e9158c5cd3825ecc40e1dc48468f7b76dabab05e76a7f1fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "814881ecbb30d5bc9d745fed4ee6e44f1bf472ec13ef33724a2129bf4c0325c6"
    sha256 cellar: :any,                 x86_64_linux:  "e9f9d9d4bdffb9ccc20effa0df2a47f159e6b34ec2f4227624b71f01f7b15ff6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
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
