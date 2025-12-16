class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.457.tar.gz"
  sha256 "b8154431e32fac177df4eae43d9443c2f0815c92667fe2571eb04400ce2ab23d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bdb3c401f464a2ddaf35f8182ccb0c177e6b6a6839d4cd5ecee74c43582804b"
    sha256 cellar: :any,                 arm64_sequoia: "c374af93f45909d85fa81646eea52f45779f2418371529531cc4b7e3ca93f2ff"
    sha256 cellar: :any,                 arm64_sonoma:  "55e9edda9d33cc053845655a3e3acf115b0cf8f8c3bb0fdad4b57a1f5c949538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d4689f0ee00993970fffcefbbd7d9ef907233d7497d82c4da2fe65f3fc3c90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e112ea5ff2d29816abb5e69fa5ee22770bf4a87a3ca7e40eec6dcc6b31a67b"
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
