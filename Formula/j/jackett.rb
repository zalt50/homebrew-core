class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1275.tar.gz"
  sha256 "853c93c0aee98ec1901a579bacf41ead9455efaea25db4eb000bb807c2b5a906"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d239e4657cca747228eaad0f3372a6e2507f7652c2527f9e2258f0246c8187bd"
    sha256 cellar: :any,                 arm64_sequoia: "0dd8b87710ebb3f910a71a6a3b14e8fce94273f54b62881ced697fc0a76c2b9c"
    sha256 cellar: :any,                 arm64_sonoma:  "0e0c7c28d8f84c964c71cd25c11318be222661c6956c320a8e8d51033cd82c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf837154c4a0b0008c1c944e3218596a5152676580a55c1f0f1c31ff91601e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c5ba6981972b1c5279aff2fced88f6985faec566fe5d836b767d9e63b3a792"
  end

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
