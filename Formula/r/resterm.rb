class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "71e52ae6c1a463511fe78e09647f01ac3ec51e718a0e64f077d59d0c42de5036"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04c2515a2a61b2aa6a8ec3977755ed5510ac7463539db1c04faa79deef907cd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c2515a2a61b2aa6a8ec3977755ed5510ac7463539db1c04faa79deef907cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c2515a2a61b2aa6a8ec3977755ed5510ac7463539db1c04faa79deef907cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ca0f325d8c0aad66128ec9a1bc104b1ebee2d0664672bb6f31ce347bbaed6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b58fed583c06c896d8be7972c481fc2532c87e87a7f6ee9237688728de95d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e3d1033c766bd506cd15cf7244889b4bd3be8a49d571327e4b2c9407ca4b8a"
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
