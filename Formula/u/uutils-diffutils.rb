class UutilsDiffutils < Formula
  desc "Cross-platform Rust rewrite of the GNU diffutils"
  homepage "https://uutils.github.io/diffutils/"
  url "https://github.com/uutils/diffutils/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4c05d236ebddef7738446980a59cd13521b6990ea02242db6b32321dd93853ca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/uutils/diffutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1f477add026e8b2295da234cfc09ec20062d59156b7a96dcde891ed18fe9eb5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b9c46a4be56b29642e8ea525e0e4f805fbb17285bb255359f20b373fb8ad189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d016794b8782c3113ba872639c5969b51f49b58e2e39956ebdca05b62c5662cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acdb4a2f8fbe583ed632f18cac365ca767af2e86739dd636e77ad8bd912e0d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bca2a21c5c80ada29af665c945506e8f592bdaac961bd6ed6fb5eb8a498e05d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6c35358ce672179dfcca353ac742008c4a674f40a6ac414f87250279ccbed1b"
    sha256 cellar: :any_skip_relocation, ventura:        "164477ab12dacdd32526a9fab350043799be6d63a0341995e86d1f170d112389"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5c26ab72d931c1a0c4f6f6c40ccf9986d4ce96b43b5e9471444d2e4351b1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbffc8e98550a7bfbacb94a2294de960775adae4472b69e3c0f57c942098cf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e18f180be6675b73db0198972f114cb11af7b36a5f8b99c005b5447d42c7415"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(root: libexec)

    uubin = libexec/"uubin"
    diffutils = uubin/"diffutils"
    mv libexec/"bin", uubin

    # Supported commands from https://github.com/uutils/diffutils/blob/main/src/main.rs
    %w[diff cmp].each do |cmd|
      odie "Check if manual symlinks should be removed!" if (uubin/cmd).exist?

      uubin.install_symlink diffutils => cmd
    end

    # Need an exec script as symlink name is used as first argument to `diffutils`
    uubin.each_child(false) do |cmd|
      bin.write_exec_script uubin/cmd
      bin.install bin/cmd => "uu-#{cmd}"
    end

    # Expose `diffutils` without prefix as it does not conflict with system executables
    bin.install_symlink diffutils

    # Create a temporary compatibility executable for previous 'u' prefix.
    # All users should get the warning in 0.5.0. Similar to brew's odeprecate
    # timeframe, the removal can be done after 2 minor releases, i.e. 0.7.0.
    odie "Remove compatibility exec scripts!" if build.stable? && version >= "0.7.0"
    (bin/"udiffutils").write <<~SHELL
      #!/bin/bash
      echo "WARNING: udiffutils has been renamed to uu-diffutils and will be removed in 0.7.0" >&2
      exec "#{bin}/uu-diffutils" "$@"
    SHELL
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"udiffutils", "diff", "a", "b" # TODO: remove in 0.7.0
    system bin/"uu-diffutils", "diff", "a", "b"
    system bin/"uu-diff", "a", "b"
    system bin/"uu-cmp", "a", "b"
  end
end
