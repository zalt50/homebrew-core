class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.824.tar.gz"
  sha256 "74330993d0b8e0893269be6c915960f68b32b4125f2271c90998cee117031da1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30bc79a7b9937b829040f8c5296dc6a26e62c4089c1592f3e4cc9a44a4386809"
    sha256 cellar: :any,                 arm64_sequoia: "7585a50f0f63edfe2c018751cb349f32e554f3ff6f74710ba84da984ee8edce3"
    sha256 cellar: :any,                 arm64_sonoma:  "d390ae542983edcf8993c4b47ffd0bc56fc82c7ae8df03d886f517170efaa5c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9ae804b2e25e731c4c9ea3210bc1edfd959cdca382a1d6cf195a85c67f98b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03e6a47113483a8d8a64c1eec8adb51c04dc9d37d9c19ba0842379a0c21535b"
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
