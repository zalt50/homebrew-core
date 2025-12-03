class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-4.1.2.tgz"
  sha256 "a0203340780a07e7214d2e1bc88a575ee431da89a2045665142a9d55f57f79eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c53555e76240d5f6ed2f4a019f8eb2623b031ba2a5c581abf7adcf61fbe1b6a"
    sha256 cellar: :any,                 arm64_sequoia: "4992118961e560fff7e22f1691b8be464c9b925bef0bd5e3157dd87105d66754"
    sha256 cellar: :any,                 arm64_sonoma:  "4992118961e560fff7e22f1691b8be464c9b925bef0bd5e3157dd87105d66754"
    sha256 cellar: :any,                 sonoma:        "02b19976489609ae42fc79c44983dc9fa790254ca862f535179e0d2e638bffff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ead68952ae0654956dd6d4868aa6ed5d8eacc4160b25292646fd8fcf3fa4372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df24655ae5a9cb4a02cd9659060dab5f7a668fb9e382161fc9a2a7ac715855f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"node-red", "--userDir", var/"node-red"]
    keep_alive true
    require_root true
    working_dir var/"node-red"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/node-red --version")

    port = free_port
    pid = fork do
      system bin/"node-red", "--userDir", testpath, "--port", port
    end

    begin
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}").strip
      assert_match "<title>Node-RED</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
