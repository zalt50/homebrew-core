class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "6f42126b594b47a445e552cf7221263ac3e56499a1828b107da7dce5e124b0ad"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6c909a7fe629c62a346f39c28bb2f9341d3a56d75bc01838d3c86f17fd8a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904e80a26606c19680c30ea46d1abd3bf81b27e20978c5e0aeeddd453c8d2e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef7a3740257f823276f8587570de94e67d5621910be12cf961a8a42bd1e8cdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bd829eec317e97b422aa49c83bb58c6012cb9d1bd742054e1a57ced7851dede"
    sha256 cellar: :any,                 arm64_linux:   "72d233218edf77afe48bf302c04f6633d0c05843b39db08bf9499245e9b0f1e4"
    sha256 cellar: :any,                 x86_64_linux:  "1ec63b8f029f3954a22cd9c8e5abb9dc60651bfe97bfa893c0a51152a6385e03"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", Formula["zig@0.15"].opt_bin

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
