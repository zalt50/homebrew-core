class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4a89e583aabf6429061737ed1442e0eead1e7630f9a7bbccaf6eaf9ca8f4f425"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea3e77251e31dd6fb74785877db4326adcaebe6d53a7fffadc57f8181d5ecf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea3e77251e31dd6fb74785877db4326adcaebe6d53a7fffadc57f8181d5ecf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea3e77251e31dd6fb74785877db4326adcaebe6d53a7fffadc57f8181d5ecf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "50cf31382767e8ed3421919e12008dc1449cf168cf045ef2cdc1d2154e40ac11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033b57370b90e1ae7def5e116a457151a4c834f36f6fe01fe1bc9a9dd5f0765b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5c3b03109c11f3571986644a0cd97c45bd662db0b2efcd060b2d9930e5a92b7"
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
