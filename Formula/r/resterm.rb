class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "0d6539d15c21bc2ed09d06370fe7c75f681c736458db86fb3136264f91988794"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fadb6c411c1a475c690e49ed375a4f6688dd4c8e728931fd0cd846e164c761d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fadb6c411c1a475c690e49ed375a4f6688dd4c8e728931fd0cd846e164c761d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fadb6c411c1a475c690e49ed375a4f6688dd4c8e728931fd0cd846e164c761d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1fd649d4ce7cc8d34681f940fd3265f2dbab059215f41380a0bfc0a38887b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afea783e1d578a827fae49011dbd0fff8a76cb3ce60b4b3015d700d4be3f1912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef19fff8383521b37100077a45916e84575ffa1377e3a078676efe5a39f0110"
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
