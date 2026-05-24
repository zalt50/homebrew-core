class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1926.tar.gz"
  sha256 "77151237ecd23c38de43517dad1763596103f028969df460f32e5928e2f7acf7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4666df3f5ef0302563d7e520bb01cfce64bbc1cf6fa49658039aa5ce2fdeb2a"
    sha256 cellar: :any,                 arm64_sequoia: "821109cf59bfae9de0cc9774bd3a20c70a3bf2c96e1a39023598e4e75bd86613"
    sha256 cellar: :any,                 arm64_sonoma:  "03f1fb7ec58ea86f2ab4dd1cdf37845c3999f2871cbedcebbccd0e539af3bb3e"
    sha256 cellar: :any,                 sonoma:        "a7cd363aa22718db93e0db6704f7b3595fa3d2e7251a0c92f932df9550e7dc10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a704bcb678cdd99198c946597cbfa4351a718071d17cbea2a39bb31b8d2d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52dab4bd3e0b3300d96cb84c69b0100b0d5faf2eb6171b26c2348e8621aa21e9"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
