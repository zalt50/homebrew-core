class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "32d00001ab7e18f2dd423c1eb61a951ff6aa5669a9cea2432951e9e558bac58d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c14563d5acc0d1f4e21cb0cce72339722a6f9e82847f02868ecd6f8cc60de068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c14563d5acc0d1f4e21cb0cce72339722a6f9e82847f02868ecd6f8cc60de068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14563d5acc0d1f4e21cb0cce72339722a6f9e82847f02868ecd6f8cc60de068"
    sha256 cellar: :any_skip_relocation, sonoma:        "20b0e730abdda8d913691db0c42eb079481f79039624eeaeb1d1ebfd0352dad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea07b43f6b9a75ec8556ccafc5af9717c78b35586243361dd069778a5792298c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b2c3c0bb36c81138b0168aa7e0075f21652c4b119fb2c3d4c628ee8776a914"
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
