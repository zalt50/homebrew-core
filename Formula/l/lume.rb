class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/cua"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.2.37.tar.gz"
  sha256 "e40b66c52fe478148024ebcdf927c75b11f2c1c852f382de686ba8fe05d02f06"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd0a7dca5fd8ea3b96e3982a546a6217f2c7a000e555e30d2dd1e313e6f4f30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b1a0669eced9bba98218b9d137e3b8109fd93b0425509023aea4a5509712d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e7249bccb1113e67397a6d457c1b91c722d3f96bb83bba1adae9b5f7941ce72"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  service do
    run [opt_bin/"lume", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/lume.log"
    error_log_path var/"log/lume.log"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    port = free_port
    pid = spawn bin/"lume", "serve", "--port", port.to_s
    sleep 5
    begin
      # Serves 404 Not found if no machines created
      assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
