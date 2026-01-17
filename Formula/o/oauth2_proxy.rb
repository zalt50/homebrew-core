class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.14.0.tar.gz"
  sha256 "23a4066a597596196d24ee34c1ef973f8d2f1f6fc8ef8597bb1665de066eb161"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac183590d7a47b6444bb7a2909f35c9e16090420ce1d794c5999c93b47fbbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f65bdab13e799aebd8d3dd1eabc7c9fd0f05bc2585b5196fada1ff8243c6b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ee374d2c834ab36e2f414d66a82ec413586c4f3433bd60ae9316d148a85cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c70c2f016353c09a35b8d061404279501cdfbbe192cea3eba93d8c89c1c6785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39771e593a32498a07bd5b0e8bef38f97e82e916c74120f76cd78c3aebea0d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f54459f459773eae013d7512410c398e964f794e3f04926423daa030a0ceb7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    "#{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in."
  end

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    port = free_port
    pid = spawn "#{bin}/oauth2-proxy",
                "--client-id=testing",
                "--client-secret=testing",
                # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
                "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
                "--http-address=127.0.0.1:#{port}",
                "--upstream=file:///tmp",
                "--email-domain=*"

    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
      assert_match "<title>Sign In</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
