class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "a079ffacd1b2b5ff2d8e770a7b04508210ddc31c4cecc85e048161106374e66b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9352165f98e651079b951564687375f7a772b70e0d98918dcc3adea00f673cb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9352165f98e651079b951564687375f7a772b70e0d98918dcc3adea00f673cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9352165f98e651079b951564687375f7a772b70e0d98918dcc3adea00f673cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c30f140690324ebca57d0bd34fa2ea5bc70cae6ae74f705e93cdc8d60ad3ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845135dc13d6067c8884a18938e80749ef32977e66a50fe8046085b6ebbe984f"
    sha256 cellar: :any,                 x86_64_linux:  "dc12543bd6f8571a182db9836e34e8bc25db6d72b51bf84c212045bb8a461c69"
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
