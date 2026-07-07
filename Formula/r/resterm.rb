class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "e19530c1d8b331537539fe89b11c82a77f7e80a9580f879099673b96c3cd96d5"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cffcbb6686995385c4531651006262184106b7c821d5d5b038bd83d62c1a5966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cffcbb6686995385c4531651006262184106b7c821d5d5b038bd83d62c1a5966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffcbb6686995385c4531651006262184106b7c821d5d5b038bd83d62c1a5966"
    sha256 cellar: :any_skip_relocation, sonoma:        "eccebfb1c990a04fb6c03ba806571a6d46db018e9f2a1deed0042eb78dedde13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1829bb8bc4161c753335dc612d0a951a9a9d7b58aa932113cf2bbc32401f0c29"
    sha256 cellar: :any,                 x86_64_linux:  "e61ca68610337af582ddd13aeb8a421af9a2661b1ed2559ac4e652d7e85bacb1"
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
