class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "75261218a8d87401b351f4c10304c01b130fbbbb445bb5e87d3a483f4c71a47e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c673751cb47cfb060436285f0d72862700790b38caeb61123cbf0cd10ba5ef8"
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
