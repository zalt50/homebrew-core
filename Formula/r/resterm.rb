class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "d3d44d45728fe4c1a0fb5f36621b555abef0cdeba179973f5f03ac4700adb924"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4459fa1cdff63bc0be94d98fdd9251d90be7e42104ed5bf9c32e7b6c9f779318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4459fa1cdff63bc0be94d98fdd9251d90be7e42104ed5bf9c32e7b6c9f779318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4459fa1cdff63bc0be94d98fdd9251d90be7e42104ed5bf9c32e7b6c9f779318"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eadfa96034267138a51d363351599ee8339ed36cfaa25475e0fb65e7898a2de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fc3ec18c051a15261f4dea22268982bb422c702328feb61b4303d68f269e9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4457a392d39539cd1f50cc133c1d02719c38785dd50d5b1d7f72ee39f9c6c043"
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
