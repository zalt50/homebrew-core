class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "d2ce49499512f7d2f830c2d425d858835e8cc58a68f97af018e05ae0e6a26fca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d859d02ee78671ee8dbda14af0956ad44ff0adbf4f76dc61bc31310199aa7903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d859d02ee78671ee8dbda14af0956ad44ff0adbf4f76dc61bc31310199aa7903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d859d02ee78671ee8dbda14af0956ad44ff0adbf4f76dc61bc31310199aa7903"
    sha256 cellar: :any_skip_relocation, sonoma:        "4757c2ab709896bc07fb6bf70ee168f1520070a5d803a179332279ee3e1c5d09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa9fb263361919198a382fe7eb79009e617be8393d41530ccca21e9fffb57b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5109cef426f20bfcd5956a662a807f14931a5a20798fc41ad19c1b6876646a"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
