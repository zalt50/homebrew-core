class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2225.tar.gz"
  sha256 "eba896a3088cd8d23ef14e35a177106c347712e604718f6b6f6f866e90ae1b5a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a7478174f332e4822bf77ccba027b1584fe7bf76e06bad6373c9add4c7f995a"
    sha256 cellar: :any, arm64_sequoia: "fe53efac03d33f27e45c833449cafa26356410b407ed6eaf31bf397c1f876d5a"
    sha256 cellar: :any, arm64_sonoma:  "a30319796658d4351e1e6c2d43c72f57da1b0350fcb232eefe4e6ac25f470b99"
    sha256 cellar: :any, sonoma:        "324fab7cbb18009d59f1abed36ae6f49b1937ed6bf3c0f200e4e979513af5340"
    sha256 cellar: :any, arm64_linux:   "9c027ff9086ea48ca1aaf3f60fc012a6c32b89686845e18dc513082435c2965c"
    sha256 cellar: :any, x86_64_linux:  "d582104c946a846564937af57137ef4f98aef66952a11ee0f95cacdeb7e099b7"
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
