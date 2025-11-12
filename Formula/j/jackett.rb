class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.296.tar.gz"
  sha256 "925a3ed52537a982d7ad88ac3a39347f48c336852f144d61a5e90f1a38038eee"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3225718e45515fdb12e196a0ec1d66710eb5b66c3f7c17db81f336a555c46e87"
    sha256 cellar: :any,                 arm64_sequoia: "ea1c85b8ede7676e8bdb38e25b3ed68a9a7de73d7721f0eb0a457ee6552d350a"
    sha256 cellar: :any,                 arm64_sonoma:  "805fb3d15e81c74281b10347195a996f2a8c752390e5d5a6aefe222723a5959b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f092a28582e77da5321d206c839287461302b79373a1549d52746e9d8a6de3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea272d610e0061002c350f92db9abc31681f8a5533d63d38a8a0538020682569"
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
