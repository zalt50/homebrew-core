class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "6c929dba67695b8d5f3439edefdf165176e5220155204b3fa7209b38593ff2df"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "904d3aa64215d16f2c1ca17082ae28e798c27aea599a86099e68a03a668307a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c7cea2213f96a066b4a75ec7acbcf170b81b89e738572774b4978a759fc1ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a58a8c60145d88fc3133894a9b21015e74410a7ed45c8c95f262c4cadf135129"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc773d88682845ce9775c3589c343d83475be6336bedce083229b61654ef23fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21a1c949795f513296a403b25f29f6b60e31bf553dc010668b02cf41cb8bd3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b53dc9c8f3b2a94dfa20ae3ebd8dc4ef7e774803bcc034a8605ba94b4498650"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end
