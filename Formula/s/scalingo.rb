class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.51.1.tar.gz"
  sha256 "acb2e79abd90c4edb5d686f12f797b602907a2719d8a155e4b698e6833983de9"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be96883a4ad960d1520addaf7e0366cacc0e2bf48b49870f46f4bec859e7e7c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be96883a4ad960d1520addaf7e0366cacc0e2bf48b49870f46f4bec859e7e7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be96883a4ad960d1520addaf7e0366cacc0e2bf48b49870f46f4bec859e7e7c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80c290a20c59467648064b1bcde61ebc7ffc847eea81b35c017c33019190c68c"
    sha256 cellar: :any,                 x86_64_linux:      "82ee210e30290d5bec9d71e81920d3c5fbeb5f0d0745aab3a33803406ae6164b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
