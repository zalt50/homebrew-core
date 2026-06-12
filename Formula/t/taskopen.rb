class Taskopen < Formula
  desc "Tool for taking notes and open urls with taskwarrior"
  homepage "https://codeberg.org/jschlatow/taskopen"
  license "GPL-2.0-only"
  head "https://codeberg.org/jschlatow/taskopen.git", branch: "master"

  stable do
    # TODO: Switch to codeberg on next release. Deferred to avoid checksum change
    url "https://github.com/jschlatow/taskopen/archive/refs/tags/v2.0.3.tar.gz"
    sha256 "fe16f839279e8baff96dcead55feb03997aebdaa3cee7a421dadc8e7cb8c1581"

    # Backport replacement of PCRE as Linux distros may not provide system copy
    # and brew `pcre` is deprecated. On macOS, can still use system PCRE.
    on_linux do
      patch do
        url "https://codeberg.org/jschlatow/taskopen/commit/555e27161057b38b5d30c1d9e2b0778d66b93622.diff"
        sha256 "b0356a7fd6dc47b77b6099b4c8fc38ed7a5932a6e059a0923985f85172e716f9"
      end
      patch do
        url "https://codeberg.org/jschlatow/taskopen/commit/2e89ece66cbc9a038f50774f1a15e9e93f4d2dac.diff"
        sha256 "2b30129c16bdf43761294a9f7c93653ce973bf81665c7b470f5e9ee487b6593d"
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c6ca32bc458061057c90fa56237a7e0d0c7e7325a9b8f18e8750b6bb822b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ad079b35dabb3834b719543b3f3ec64373cd538bf9920a8c801543f43c408a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ab00cba3ecabd049d3852c0dfed545462ccab1bce5072591eb4d27c5758071"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0350d52c91cd2aa71a76feeb6197551d65a6eb3e9e2cd9150691742e0c6549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822855f8d7f1453c212863347f73a256b63f7939a9f32a03f6ff216816557d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58603d593ac29b6893b614cdde533fac5c6c3271383303698081e11e9fdc364"
  end

  depends_on "nim" => :build
  depends_on "task"

  def install
    # Workaround for https://codeberg.org/jschlatow/taskopen/issues/180
    inreplace "taskopen.nimble", '"2.0.0alpha"', "\"#{stable.version}\""

    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    touch testpath/".taskrc"
    touch testpath/".taskopenrc"

    system "task", "add", "BrewTest"
    system "task", "1", "annotate", "Notes"

    assert_match <<~EOS, shell_output("#{bin}/taskopen diagnostics")
      Taskopen:       #{version}
        Taskwarrior:    #{Formula["task"].version}
        Configuration:  #{testpath}/.taskopenrc
    EOS
  end
end
