class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "a86577ac51a0f59ea3d57776c5e346833247618bd4e6a716041cf4ab9fa5fd9c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f104b543afe55a2f341ebd50135cd1a0c4b20d4e19cdd8d564072ad2ff1c810"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f104b543afe55a2f341ebd50135cd1a0c4b20d4e19cdd8d564072ad2ff1c810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f104b543afe55a2f341ebd50135cd1a0c4b20d4e19cdd8d564072ad2ff1c810"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0e510e6f427f640055bf2c8f0d89dad45b9c540bdeccd6d5ca787b6247d98ed"
    sha256 cellar: :any,                 x86_64_linux:      "4dfcf01a0ec7861dfb9568f34361f3e8e18dc8a980015754b1e3af066eec69e7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
