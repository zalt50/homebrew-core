class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "9c72e91313b61219467cbc43187ba687fec4c298c660f655f70bcc8974d88a00"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aca4d622c0b623485b8af55236896b661cf576d1c9a71091ce509263df512a4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca4d622c0b623485b8af55236896b661cf576d1c9a71091ce509263df512a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca4d622c0b623485b8af55236896b661cf576d1c9a71091ce509263df512a4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "824f552de6cd985c8e01f1b5395da7eb0f1f7f7e84cb90d1d13c048e30ee73d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c89d9ec00faed0442d6cae30564b436a4aae2b207f6d836eae149d17ed0eb05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440976457efdc65658af68ff95ab0720977901c141009ed13bc5f853f18e05f8"
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
