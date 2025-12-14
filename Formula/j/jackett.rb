class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.448.tar.gz"
  sha256 "9b1404fce245c538824726367dea4419ffc8318de2fe1047ce7527ac30d57b6f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "377483a03378470cabfa5f4d9cbd35830fc1e30d5f5372f446cfcab3b73c4ca8"
    sha256 cellar: :any,                 arm64_sequoia: "37d6316de3aa0d957a0f1858c44b276889812eeaae487ef82d077cd551a32a7d"
    sha256 cellar: :any,                 arm64_sonoma:  "4dacf88e99824b4b18e855193b3ed4803b4f390d42819a303ab14e8d999b8136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d218df0baed45a9178a8aa46c40cc8a495f72cd49dac80015a8172e2232135f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcacd52cd0f90ad9cf43aee0f651def7e43ba6718ec15ef56af36ceabaa6fc84"
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
