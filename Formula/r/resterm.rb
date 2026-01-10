class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "886f61ef6e583a904522766e8a13b25d7c42273ea3b454f58f1795899145b68a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f1968b8d2cbf15b8195f33a199790dc5493e5f8bf3c94351c8ae6ea6775251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f1968b8d2cbf15b8195f33a199790dc5493e5f8bf3c94351c8ae6ea6775251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f1968b8d2cbf15b8195f33a199790dc5493e5f8bf3c94351c8ae6ea6775251"
    sha256 cellar: :any_skip_relocation, sonoma:        "de66401b259f4e619c8d8e5c5023ab531189b15982596c52fa3c7bddb211c72c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62cd45c017f3ffd240591d59250a4e268510158acd8aa3b5813a2d9621b15bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094082d55f600712a158f64003f8c48a4e712cc5f5b332da972698a71565db97"
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
