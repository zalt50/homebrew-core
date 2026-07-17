class Utiluti < Formula
  desc "macOS command-line tool to work with default apps"
  homepage "https://github.com/scriptingosx/utiluti"
  url "https://github.com/scriptingosx/utiluti/archive/refs/tags/v1.5.tar.gz"
  sha256 "84acd1d0e63d85fcb4663639f040ddc5763a2ac317a6e1613de2d2c245faabc7"
  license "Apache-2.0"
  head "https://github.com/scriptingosx/utiluti.git", branch: "main"

  depends_on :macos
  uses_from_macos "swift" => :build, since: :tahoe # Swift 6.2

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    system "swift", "package", "--disable-sandbox", "plugin", "generate-manual"
    bin.install ".build/release/utiluti"
    man1.install ".build/plugins/GenerateManual/outputs/utiluti/utiluti.1"
    generate_completions_from_executable bin/"utiluti", "--generate-completion-script"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/utiluti --version")
    assert_match "public.plain-text", shell_output("#{bin}/utiluti get-uti txt")
  end
end
