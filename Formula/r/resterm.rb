class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "23387ff60dc6223c81407ab70786f598a31ebf4b5cb4a96281129d440e8e7785"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "187fd1ac18d0c5e94304e6b81441e32105bc9aca1ee27ef10ca6e0c6327a04a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "187fd1ac18d0c5e94304e6b81441e32105bc9aca1ee27ef10ca6e0c6327a04a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187fd1ac18d0c5e94304e6b81441e32105bc9aca1ee27ef10ca6e0c6327a04a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a9d38a445c957409705b41a2de553ca003ba9851aef190bdfdaf0f3c3c27023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63290cf913fa3fd43bcf77191c7edb64e756ec32657da7d867bfdd99fc8e11f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9669f0419af177dcd4ea2d26c4c9785e87b0c3dd24c6ad01fe6d2133dac7f9b"
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
