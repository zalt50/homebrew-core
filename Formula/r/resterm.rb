class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "72ae7400ff5ea7bd7dce4a34a81e43e38a456dd55ccd23df6a9a3304fb8bfb15"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa358d1a37d8a359c76bfb25fde11a0a0960cd95a5aab81ca16c34df71fb7511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa358d1a37d8a359c76bfb25fde11a0a0960cd95a5aab81ca16c34df71fb7511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa358d1a37d8a359c76bfb25fde11a0a0960cd95a5aab81ca16c34df71fb7511"
    sha256 cellar: :any_skip_relocation, sonoma:        "a445d1954630750e98b59d7798f6c412dbfdaa43100a7599cd413b02df1ae6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a446bf4d67dc8de1398ee259fd31bff33368d6c14a508dc4aba7b01f1f506a4d"
    sha256 cellar: :any,                 x86_64_linux:  "d3be6219501eb686c2aca702f9da1ae386fd54b23df0fb60345012bf9baefd15"
  end

  depends_on "go" => :build

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
