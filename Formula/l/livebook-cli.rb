class LivebookCli < Formula
  desc "Code notebooks for Elixir developers"
  homepage "https://livebook.dev"
  url "https://github.com/livebook-dev/livebook/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "9be368c4a8c58f780af453e21b52dd17204390a037cddc119230787b2e4de58e"
  license "Apache-2.0"
  head "https://github.com/livebook-dev/livebook.git", branch: "main"

  depends_on "elixir" => :build
  depends_on "erlang"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "setup.prod"
    system "mix", "escript.build"

    bin.install "livebook"
    bin.env_script_all_files libexec, LIVEBOOK_SHUTDOWN_ENABLED: "${LIVEBOOK_SHUTDOWN_ENABLED:-true}"
  end

  test do
    ENV["LIVEBOOK_TOKEN_ENABLED"] = "false"

    require "open3"

    port = free_port
    Open3.popen3(bin/"livebook", "server", "--port=#{port}") do |_stdin, stdout, _stderr, wait_thr|
      # Ensure that the server starts
      expected = %r{^\[Livebook\] Application running at http://localhost:#{port}/$}i
      assert_match expected, stdout.readline

      # Ensure that there is a page to visit
      output = shell_output("curl -fsSm5 --retry 5 http://localhost:#{port}")
      assert_match %r{<title>\s*Livebook\s*</title>}i, output
    ensure
      Process.kill "TERM", wait_thr.pid
    end
  end
end
