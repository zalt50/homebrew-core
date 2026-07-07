class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "86f4ade98e4fa048b99ad59d1453da00b691dcdf559bbd18441f495b448c02fc"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7d94052b25e30c0175f40cbbd7fe30aae9e68ae1a519d116f8fadeaac3905b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef9d69af7276c704329114793035388498d19ca4e0995ececa2c0eb9b212a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47f812143e7318724c04241f10bd8080b4ec48ccefa0aff4b4af6e410b6c0a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a55285fb6fb7efd6da4b6f9b6b84f26e5f706d55cf1f05ce45bf58609f80cb"
    sha256 cellar: :any,                 arm64_linux:   "e7345ee9bf8d24f7a137a32f9f15ab84b66d05d4dc0c5e27304a137ca3badae1"
    sha256 cellar: :any,                 x86_64_linux:  "3904f8dcb0e0d342277510a4947a1c3f30d3a79146d404dc5c7f0b8e1f017d05"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herdr --version")

    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s

    pid = spawn bin/"herdr", "server"
    status = ""
    10.times do
      status = shell_output("#{bin}/herdr status server")
      break if status.include?("status: running")

      sleep 1
    end
    assert_match "status: running", status
    assert_match "version: #{version}", status

    output = shell_output("#{bin}/herdr workspace create --label brew-test --no-focus")
    workspace = JSON.parse(output).dig("result", "workspace")
    assert_equal "brew-test", workspace["label"]

    output = shell_output("#{bin}/herdr workspace list")
    workspaces = JSON.parse(output).dig("result", "workspaces")
    assert_includes workspaces.map { |entry| entry["workspace_id"] }, workspace["workspace_id"]
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
