class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "2df783f335a83950988d055b7f8f2b88d926bed0faab6be3df5447b1804fb64d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c108d7ea7074ac448c1873bb14d2aa4d93ae71f668ac678ced21c25f0df85a39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c108d7ea7074ac448c1873bb14d2aa4d93ae71f668ac678ced21c25f0df85a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c108d7ea7074ac448c1873bb14d2aa4d93ae71f668ac678ced21c25f0df85a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef50b42bdf24ef1ce5eea61d93cb630c906c9932ee091eab3022e77bbc18bb38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0d6015355c5d762b41b7d00ab4243ee8135bbdeafa887c8541ff56160ccb31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f98db9605f9054feb22fcdb634a6afe189a9ee4e61f1f3ba70fd25f017d06b6a"
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
