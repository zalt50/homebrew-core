class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "6b27160cea8ca6e5ab3fefc531c3aa6264a507459faa4bdcfe8d5169b083c50b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8698ffcd4209885374ff314e555dff02e518496400f5952357b753b44a388c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8698ffcd4209885374ff314e555dff02e518496400f5952357b753b44a388c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8698ffcd4209885374ff314e555dff02e518496400f5952357b753b44a388c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd8e81f02e706b34194376ff1f4c207ebb3d7f19809e629f71815425ab21b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b99dc8899c22f709abeace15127de47344776a7d6f778bb6aae2450983bb2699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3314de1c6f2b9f35f4de8d30dcff7db8a89896a5802dbe2f041ca17ee3ceda8a"
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
