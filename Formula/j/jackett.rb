class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.726.tar.gz"
  sha256 "16c6018772457666a2f7339a6b62e646f94f2d58772e0366ed9be3415f3dec14"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c96e40b25c753565f6f5e81dece1e422f354f34ac5dc5ebdfef4638dd5852f9"
    sha256 cellar: :any,                 arm64_sequoia: "c83b621c5340f13255115cd2b93ce3bae615095284089111afb79d72c010527f"
    sha256 cellar: :any,                 arm64_sonoma:  "29b2fdd2b5fac90fe826f8e893106ba88dea33f5803eafa8a1bbb4eb2be31540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1393ec771d2cf44080fdbfb75d07c70fedbec272d46696960eb34d15ad01a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce1b33a5d34d86713ce545536600bb32d3960f439983f621c08c1b862fe6ae2c"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
