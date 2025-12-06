class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "f6e2ea2b16f5684f5b411c7b755327d88fa07d270b5714f889fc9e85b8a7f1f9"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f9ed81feea125343338f9ffc7ecb09ac657cd6d24e75f7d004be18f0206af87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9ed81feea125343338f9ffc7ecb09ac657cd6d24e75f7d004be18f0206af87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9ed81feea125343338f9ffc7ecb09ac657cd6d24e75f7d004be18f0206af87"
    sha256 cellar: :any_skip_relocation, sonoma:        "0894d476882d0127a0ef19337414f11652c2adc5c6dc71551e0c6209419ac2f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5521626bd4547e5237ad106aec0bdd235093f42bc551d116040248680f4816bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dbcfaa56faf41b9d04e1cbff53697c240f1ca71b9c251eac9d605f5a2480787"
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
