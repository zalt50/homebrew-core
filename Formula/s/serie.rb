class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "74e07c0fd3163e5510347e13d8242f66777a02d7125c58ebc7a83bd2b5814018"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df909b1de16a46f7dd5ec860e9f18c4e58630312fbc589aef3f95b3a42ca4751"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc59da51297d2ac530350064027c606022716a6bc807583989ef471c2bb3349a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b1c9ed10ddcfd0e82c971e111a5802ad40d7440176e7bd9f31d11b2bd9b8a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f6c71a3e80c23cf751d8c9df2b421194b2516ee90083753144dd3cb6f6f50c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "690f20eeea59b1520288ea1dfcc492aa802224f13d892ab41dfd161f16bfa729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb836a4ce168366f96261104c4fc4b3a5448156fc13d4d98923666c4d472989"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
