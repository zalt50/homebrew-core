class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.6.0.tar.gz"
  sha256 "15504114bd2a275dde16999d075b17e7d84989b1c54e07dc0c91574d113752e2"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e88e304b357698f00953a7fe92b066fdd98bea0168cf912c798ab9d34fa8b2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fcc186e59354940f7b80c1f355506b9cab495746ca02cf9433174894c2f27e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c11c08f73beea8ca67e6818a712a42aaa0aa7f0d5ca441d1195add3963cf1d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6521bb8d08428cb9bc58d609af0c926d83a0856b3e9aa7bd28726eaf4c9b0e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38db0fb6258a45e6156597ad28cf166a2e498cb7481618762d89de9e5f243982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13f8518ac96dd33787b1bc6d0caf99bf7a17f3733e22ddd88cca76fdfc37319"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port
    pid = spawn bin/"wstunnel", "server", "ws://[::]:#{port}"
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
