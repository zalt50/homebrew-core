class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "ac92386dc9bb9c2817454951118f589543a6d6e5d53e339983a02cecdb66fa15"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4118d1134637e6b220b437b71288801f7327c1f32e88e7c140e4ee242e28a67"
    sha256 cellar: :any,                 arm64_sequoia: "aabbea7eabdb0a772467e2e09730737084b6bf70f4f43ad95bf559b7994fe6a1"
    sha256 cellar: :any,                 arm64_sonoma:  "eb491b4df2da04fecf8a4bb7d462e5ffcc391941d5ca958cf55f1a706e7a85e4"
    sha256 cellar: :any,                 sonoma:        "584294f01ac5dd9d6ce3d1229fa64e397b9ccee45a02342595f1826e2d72cd8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a61e98009c8735940fb579db97c3f1b746488c674206c2afb1907da12c0eede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267f860b4746ae4b8ad20aeab7b2922cc7ae3fef092f03a626e4a8e8e4cef25a"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    assert_match "It works", shell_output("curl --retry-connrefused --retry 4 --silent http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
