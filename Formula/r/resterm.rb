class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "7672b52d3745d09be1b43614066f97923cc8485489c31e97a3d67f6c4aafc64a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35fda30e42b51b1eadf2c9590f5a47589abf8abff2e8a343ebdf82b26827d1f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35fda30e42b51b1eadf2c9590f5a47589abf8abff2e8a343ebdf82b26827d1f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35fda30e42b51b1eadf2c9590f5a47589abf8abff2e8a343ebdf82b26827d1f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcff24bf381624f545bb1ae0ea166fe56d3a82849f7b649b4361596702c8a60c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d90ff04da683ab18bc49fd8cd1298818e10f73814ca0767e82667deee00e8f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "380c8179a36b91af672f110d58cbb92169945aca70b7fec4c31d4c04f88b4703"
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
