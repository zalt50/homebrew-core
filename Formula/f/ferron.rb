class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.3.0.tar.gz"
  sha256 "053f7ffb14e549f38f9702b2ad13ad321549799484121a02cba4714eb32242a2"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f63ad1dd89e2c2b7c0499361f3ea048bd6549371730fd41128e009f4ca19ceeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aaf9f3f7e2a0553eba7bd8ea5c1454b37cf96d2ca57ee4bd970a05241d33fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977b0b36e9e05c5023d0d173aa26aeda1b3af78da32102614afbe581eeec1b75"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe40b9ab746846878f78c0a13aa932033d29722fda943f79f50c79a7e63af172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dc3e789d2bd69397d6d8f64d49a1381cbc187a83e64042ac22d53daf81161ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f030f4dba7f836be05513b92868c63e9a1f56aced1f744a9444393e9721cda50"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!doctype html>
             <html lang="en">
                 <head>
                     <meta charset="UTF-8" />
                     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                     <title>404 Not Found</title>
                     <style>html,
      body {
          margin: 0;
          padding: 0;
          font-family:
              system-ui,
              -apple-system,
              BlinkMacSystemFont,
              "Segoe UI",
              Roboto,
              Oxygen,
              Ubuntu,
              Cantarell,
              "Open Sans",
              "Helvetica Neue",
              sans-serif;
          background-color: #ffffff;
          color: #0f172a;
      }

      body {
          padding: 1em;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          max-width: 1280px;
          margin: 0 auto;
      }

      header {
          text-align: center;
      }

      h1 {
          font-size: 2.5em;
      }

      a {
          color: #f47825;
      }

      @media screen and (max-width: 512px) {
          h1 {
              font-size: 2em;
          }
      }

      @media screen and (prefers-color-scheme: dark) {
          html,
          body {
              background-color: #14181f;
              color: #f2f2f2;
          }
      }
      </style>
      <style>html {
          height: 100%;
      }

      body {
          display: table;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          height: 100%;
      }

      .error-container {
          display: table-cell;
          vertical-align: middle;
          text-align: center;
      }

      .error-code {
          display: block;
          font-size: 4em;
      }

      .error-message {
          display: block;
      }
      </style>
                 </head>
                 <body>
                     <main class="error-container">
            <h1>
                <span class="error-code">404</span>
                <span class="error-message">Not Found</span>
            </h1>
            <p class="error-description">The requested resource wasn't found. Double-check the URL if entered manually.</p>
        </main>
                 </body>
             </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
