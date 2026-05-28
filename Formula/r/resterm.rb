class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "1f8038c80e9855c55451b434d6ae6e2bc79767486f418d93a21c7b2c7786c836"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ec54e4f606825c0bd2d8e5ab7e18d6370c92b8e557c85208ddabd6d0f8f7fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ec54e4f606825c0bd2d8e5ab7e18d6370c92b8e557c85208ddabd6d0f8f7fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ec54e4f606825c0bd2d8e5ab7e18d6370c92b8e557c85208ddabd6d0f8f7fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a07c07f0bae96e0fee48d56741743c71ce75210c68889542a006f4ba8a7f8d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08d0bbb328ea0c27b3852493fd59063460169152e39a1fc82247f024b7134b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd37a3451a3c3694197d0db679b3d50c7d7efd108fd9f321f8f65b3a4b0d782"
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
