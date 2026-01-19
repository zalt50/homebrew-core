class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "908300013e7e2722b044aa598d0c9ffb799cebf9214fefe1be3e67958dcfbe23"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    ENV["REPEATER_OPENAI_API_KEY"] = "Homebrew"
    assert_match "Failed to validate API key with OpenAI", shell_output("#{bin}/repeater llm --test 2>&1", 1)
  end
end
