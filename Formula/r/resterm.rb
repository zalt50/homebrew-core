class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "184be8bc66fe0395456ce4ab1f69574c208d09f35f61f67054d0ff0d169e4217"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d721b36b0d80df9303b38872d23449763465ccd9a854eff41c1afa891b3e3f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d721b36b0d80df9303b38872d23449763465ccd9a854eff41c1afa891b3e3f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d721b36b0d80df9303b38872d23449763465ccd9a854eff41c1afa891b3e3f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1caa85a0d2a39048fd0bc4db31dfcb4c44f20722beaeab89df02d34ea063ca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85df21c4a3956704a39f97961a737c9d143c74907b31755383933610846d025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd8c099284006d1abd411f3d23440ec02482995bbf5799a75ababa70ccfa173"
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
