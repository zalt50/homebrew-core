class ZshYouShouldUse < Formula
  desc "ZSH plugin that reminds you to use existing aliases for commands you just typed"
  homepage "https://github.com/MichaelAquilina/zsh-you-should-use"
  url "https://github.com/MichaelAquilina/zsh-you-should-use/archive/refs/tags/1.10.1.tar.gz"
  sha256 "04e77d717a14cc07f81c5ad38d64618c6f2a762d2168fb8aec2b273c7d0eabfc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8245005cafa46b294b2e4d747322bba4d6c05cdee2c34cda2b8391287ce0855"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "you-should-use.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate You Should Use, add the following to your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c '. #{pkgshare}/you-should-use.plugin.zsh && " \
                   "echo $YSU_VERSION'")
  end
end
