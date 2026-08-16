class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2414.tar.gz"
  sha256 "8fcee953bdee229536f23569e7fb94c247de396e46255261f3f635fc53199224"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d492fd6c42fd124622aa9b2ce79fe82ec39c001f809b673088ca5d7822653a5"
    sha256 cellar: :any, arm64_sequoia: "3a64327fc389c7d68afd0ce5f7a194c1e5025ec17dedab0083609d731db6888d"
    sha256 cellar: :any, arm64_sonoma:  "26bfea1a1a4f106879f5d404c07a55eb7972784004aea15a1006be1893c529ff"
    sha256 cellar: :any, sonoma:        "a7cbd9ab9b2eb36e2d137d2d9ca18d60f29e389f89238e181ac3347e146924c8"
    sha256 cellar: :any, arm64_linux:   "5b00aa6bdb1879c7c470e029ec7574643564c8b0d243ef64cb7120e7b93bb841"
    sha256 cellar: :any, x86_64_linux:  "1877dff48e191bd4b050d9089061b075b8de7193520eaf6329823dbfa55cb5b9"
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
