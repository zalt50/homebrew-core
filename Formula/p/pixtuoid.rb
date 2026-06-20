class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0785360dfd4133b910df0e6dab4d2e35df9c6c975cd925ce2bd2bd414ed7505d"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  depends_on "rust" => :build

  def install
    # Drop upstream's x86_64 Linux lld linker pin
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid")
    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid-hook")

    (man1/"pixtuoid.1").write Utils.safe_popen_read(bin/"pixtuoid", "man")
    generate_completions_from_executable(bin/"pixtuoid", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pixtuoid --version")

    system bin/"pixtuoid", "init-pack", testpath/"pack"
    assert_match "OK: pack \"skeleton\"", shell_output("#{bin}/pixtuoid validate-pack #{testpath}/pack")

    require "json"
    connected = JSON.parse(shell_output("#{bin}/pixtuoid connect claude-code --json"))
    assert_equal [{ "id" => "claude-code", "outcome" => "connected" }], connected
    assert_match "pixtuoid-hook", (testpath/".claude/settings.json").read
  end
end
