class FzfTab < Formula
  desc "Replace zsh completion selection menu with fzf"
  homepage "https://github.com/Aloxaf/fzf-tab"
  url "https://github.com/Aloxaf/fzf-tab/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6b9c82c73ceb70ab13d1b6ef07c7bda7d43a3c507152dc156f783f1f1a6774ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24223cd008a939bd2cc6bbca48e8fa942ff8ef91dd304e35206fa9852e7ced2c"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "fzf-tab.zsh", "lib", "modules"
  end

  def caveats
    <<~EOS
      To activate fzf-tab, add the following to your .zshrc:
        source "#{opt_pkgshare}/fzf-tab.zsh"
    EOS
  end

  test do
    assert_path_exists pkgshare/"fzf-tab.zsh"
    system "zsh", "-c", "source #{pkgshare}/fzf-tab.zsh && (( $+functions[fzf-tab-complete] ))"
  end
end
