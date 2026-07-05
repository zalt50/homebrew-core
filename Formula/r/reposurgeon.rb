class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.9/reposurgeon-5.9.tar.gz"
  sha256 "f1b2c8f76bfaf6bfe19a625bb14c5e4c9a494c17f4591bdbc6c7796226d7365b"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b66e384d20675f69c9d473e6c030a9232cfe8d8c327b7bfd21bf227f7b90a761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b709ec1a84895f07c70a41afe1cfb7d4e40a06c6399073155a16ffade11fe8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf63784ae1a28e800feb2349a0901bae8208ae5ba1f65a7325e0d7669a5cf452"
    sha256 cellar: :any_skip_relocation, sonoma:        "908ff53638bd99e6a8226a4ef11b3d61debd4ba657b44fd43f230eba1fcd11ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67b5e1d7fead416624377d20e5c5148f326e7c10da4ac06776d273f965a8337f"
    sha256 cellar: :any,                 x86_64_linux:  "3d42f3534c2f7a5f8012ab95b8b78a94c7b05193aed5735116dab7be77694aab"
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
