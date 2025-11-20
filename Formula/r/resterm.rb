class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "cef0e5d33e9ab20bab6f9cac2394545369fe16f9c6f3c3801948be53c2c463f7"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f80082c1c83d28ce680aec8fe7761836fc34e230ab1210e4768c8ede052dbb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f80082c1c83d28ce680aec8fe7761836fc34e230ab1210e4768c8ede052dbb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f80082c1c83d28ce680aec8fe7761836fc34e230ab1210e4768c8ede052dbb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b49e1281b27b0c4771cc5322dc209a2deb6e1f004d573d262fbc78c9dfd903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4c840faa5aecf2dfd96793d93ae7e16c894063031e7a50723b197c7b72e36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d89cbd0344db90821ca2a877d8326dc138ab026501f075dbb2490fb8a5f64d"
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
