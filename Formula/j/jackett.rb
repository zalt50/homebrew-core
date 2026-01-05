class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.726.tar.gz"
  sha256 "16c6018772457666a2f7339a6b62e646f94f2d58772e0366ed9be3415f3dec14"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b80e236022fe087fb2becca64cfe126d3cb302a47bc361917782fbef5da848dd"
    sha256 cellar: :any,                 arm64_sequoia: "17ff4c2ccbbc41a482130600bd75110b524d91229ca3216b4b8768763ef3f735"
    sha256 cellar: :any,                 arm64_sonoma:  "68e8f10ee3f091dd0a545879749cf5753f1d7db07160620c0263566387733ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c11996d48eabc0bb645a6f600a528bd60f029e341de639f13c8f9a78097c9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a5196b417d0d489005a218a1a589932a42cf9f0780a551b5e6ea4345dba01c"
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
