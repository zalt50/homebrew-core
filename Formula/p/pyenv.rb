class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.25.tar.gz"
  sha256 "7e1e369c5d0ef93294002d166eb81a75e6c24792fa6dcea8be5980ead9b780a0"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ee97b12186ee3af30f93dd03f688405acea54124687e85093af408e65f6cf15"
    sha256 cellar: :any,                 arm64_sequoia: "e19f88f654395a6d3c68ae6c5e632256394c121696ff9895de39e231050fc564"
    sha256 cellar: :any,                 arm64_sonoma:  "330850522f333274bb172562b1811aadaea8b21611925c4df71bb6c0e7148baf"
    sha256 cellar: :any,                 tahoe:         "11bb4c10f3aeea038765387d1b39ac620b6432e7dd8b13a952083027cdfd50c1"
    sha256 cellar: :any,                 sequoia:       "21517606a96a6c2935592662aefd09bc7f2fd96aeab1879711a66e1ac5b8ac35"
    sha256 cellar: :any,                 sonoma:        "c5de9683098bfc155f6bb083bcf0322e8bdee85f5ed820a3038cfd6ae86cfe81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee369bbb8b3d7d8ff69225c468d33ebc491b8d04be9998fdf3af6d27302bf04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6e4cf40600a27a62542b96e54ad02a4f81cc075c67b5e6e363a8b934c97c3b"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}/pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& #{bin}/pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
