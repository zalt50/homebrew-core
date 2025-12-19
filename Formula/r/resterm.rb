class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "90746993fd5ed26fe7cbea3142c870df2ff855501c8c64c0c3506b4931e8c187"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fff794ad5b1af628957f3cdb3afe95ce48986f10fad03a2818662f1845485372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff794ad5b1af628957f3cdb3afe95ce48986f10fad03a2818662f1845485372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fff794ad5b1af628957f3cdb3afe95ce48986f10fad03a2818662f1845485372"
    sha256 cellar: :any_skip_relocation, sonoma:        "19baa29455db7048c906f2b26f77e78124f37578d8ca64c8a975ef0b37a3828d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fca383df25b1f796d0ff11b92079aaadfc570a7d5c8b70eafde94925fa89077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07e2005b833e2e3e8c3375895530c9a50efeda2390a823d5b38daf2302caa392"
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
