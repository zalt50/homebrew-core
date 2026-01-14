class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "184be8bc66fe0395456ce4ab1f69574c208d09f35f61f67054d0ff0d169e4217"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "306e8abd312cfdf97d17e0e1568c9178709252a2a8c1c97d1559d2e357f8dfb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306e8abd312cfdf97d17e0e1568c9178709252a2a8c1c97d1559d2e357f8dfb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306e8abd312cfdf97d17e0e1568c9178709252a2a8c1c97d1559d2e357f8dfb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "69c675f460ec43f410ffb62bf2028e1d1e867b72ff62c8a7f5da2bf6982df039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85472515bef03854a3d7dcc15d51f86f699de967cb43c91fd08535d55a8a9bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d41f1662999464e43b049cd2b160081f7e86a14ada52e135f5fc78c775eaac8"
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
