class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "efa98b8604faf6d76a2a09ce2e7b4e97f6de71c0213bdeb4ed8d2b6c23b861e2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29db86f52f04adf62b20a68fdb2227a2169226924b59f4ba86a3b6e52c7d9f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29db86f52f04adf62b20a68fdb2227a2169226924b59f4ba86a3b6e52c7d9f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29db86f52f04adf62b20a68fdb2227a2169226924b59f4ba86a3b6e52c7d9f25"
    sha256 cellar: :any_skip_relocation, sonoma:        "2957c85581880e587fddb3fd2f6d2441c53966fcebb84e501e451d2891d90ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245e03869f10de3fc6a6f358bb912422a475686ba808aaad1ce5f3779cda7a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412295f9c77b8be1bfed11a30b085d667b1563d41a5f30df9e5171921ea150b4"
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
