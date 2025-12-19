class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "8e9a829140e4523f56459fb3613d5bd6a28e2bb56a05edda96a57cdd791be662"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d40de815ca8e839b8626a76f044944a7f141dd81b6cb5113d04a70b7c7920e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d40de815ca8e839b8626a76f044944a7f141dd81b6cb5113d04a70b7c7920e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3d40de815ca8e839b8626a76f044944a7f141dd81b6cb5113d04a70b7c7920e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d571d96d24267232475decb664aa0c737cec5849618198fb4a7c15ef6f6a5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "946d8bdc51bae1383a7d85c92224c20a7789a32f087130e287782f42a57a4464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322eafe2ae99f8d9cb0dfec36476ca20915627d14ba594102989adfb645ad60c"
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
