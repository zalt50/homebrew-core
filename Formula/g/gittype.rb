class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2efb51de5b8e00a4bc0086a3811e473f5934ca08750a32bcc39b19dfdeff68e7"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end
