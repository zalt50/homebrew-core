class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.10/reposurgeon-5.10.tar.gz"
  sha256 "f001d1e2b9c54797f9a3f84fb5d55ef9113a53c645d7bdb617a2ac1de3bb0ed5"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06375c486d9a0a8a6e227b96104c02c2f461d6275664436fa8b91e37402ef206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e42887e6dc400e5b2d381188e520fac92cba80cd99377bdb04e95ac24b5c403f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e181830306d8e99c3501ebbe88236a93a261b7c8955c79e244c6bf104381f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d58a92e266dc822e0cec5841a586edd12df9f34900179fbd37f3c9aef70664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8337000ace833c5a4f90924a1c38cdbff706a706a537f41fd161159539186d13"
    sha256 cellar: :any,                 x86_64_linux:  "33d152d7c5a9cac220f4c5053c10ef4142081871c7c1f232c28c592e2909c5f6"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ruby" => :build # same Ruby as asciidoctor

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", formula_opt_libexec("asciidoctor")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end
