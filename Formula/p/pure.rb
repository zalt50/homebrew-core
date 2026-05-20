class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "b6fb24347bd4ab9eadfce1c4dcf18111763dc47e6df3e0bc5d485ab9a5ccf36b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ae83a6fe10848f0a5f7ef681a49c5f3308dad29fbdfef32c57bd5eda7bc8989"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end
