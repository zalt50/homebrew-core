class Portless < Formula
  desc "Replace port numbers with stable, named local URLs for humans and agents"
  homepage "https://portless.sh"
  url "https://registry.npmjs.org/portless/-/portless-0.15.2.tgz"
  sha256 "f5ec8af5a7620065e9d9a4fd912382f5f4cb1e9c57763308ba99b44b48cc5ff4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd3a4d064f35c48327a673f61830687acd3e5c58ba1c833612c69ca0a650c909"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    proxy_port = free_port
    server = testpath/"server.js"
    expected_url = "http://myapp.localhost:#{proxy_port}"
    expected_body = "Brewed fresh"

    server.write <<~JS
      const http = require("http");
      const body = "#{expected_body}";

      http.createServer((_req, res) => {
        res.writeHead(200, { "Content-Type": "text/plain" });
        res.end(body);
      }).listen(Number(process.env.PORT), process.env.HOST);
    JS

    ENV["HOME"] = testpath
    ENV["PORTLESS_PORT"] = proxy_port.to_s
    ENV["PORTLESS_STATE_DIR"] = (testpath/".portless").to_s
    ENV["PORTLESS_HTTPS"] = "0"

    pid = spawn bin/"portless", "myapp", formula_opt_bin("node")/"node", server

    begin
      output = shell_output("curl --silent --fail --retry-connrefused --retry 5 #{expected_url}")
      assert_equal expected_body, output

      assert_match "Proxy stopped.", shell_output("#{bin}/portless proxy stop")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
