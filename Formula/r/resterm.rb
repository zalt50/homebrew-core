class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "23387ff60dc6223c81407ab70786f598a31ebf4b5cb4a96281129d440e8e7785"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c81b7477ac4e3a24f7233fe5598131392a3f596b3889c3cfdbf22623b28a0318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c81b7477ac4e3a24f7233fe5598131392a3f596b3889c3cfdbf22623b28a0318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c81b7477ac4e3a24f7233fe5598131392a3f596b3889c3cfdbf22623b28a0318"
    sha256 cellar: :any_skip_relocation, sonoma:        "f38169cfa525559f4ab48e09a5d66e8326de06766dbd6d8a632025d6f13556f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c392c1c6a38e2fbf8d39f1c651315cdeb071528ee0982da8baf314f69aa92f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff4553d77bf6e7de91693eff56152d77c9f63e57ac53949aff6f1d6af234950"
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
