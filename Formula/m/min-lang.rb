class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://github.com/h3rald/min/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "bf5035da045549e4a3fe1aa3a52ecb07f1567750b463b8644a717a9bb5d2d6e1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee272da9119a9d8ac9ee275432ab9080b489c72a455dc78271e06ba99384ae6e"
    sha256 cellar: :any,                 arm64_sequoia: "8399829175c176bb0ea4ce67fffabaa0490f5f27cdaad94a0e85f13ac5d328b1"
    sha256 cellar: :any,                 arm64_sonoma:  "a1aaa0a0ff13198583d3ee3d1311a8413604463632527e374b57cf2b89849466"
    sha256 cellar: :any,                 sonoma:        "5efb0040601531de44509ae49cc917532a7186256fd1d13b4b099ab6d270f306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ffdbee6b05b6db4a6397efc19bb5a0a90b9eac22aa091bb328122f556ec5541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "530dd9de53c97214116718d0c808fbe758dc531d526ee84461e5118d1f854422"
  end

  depends_on "nim"
  depends_on "openssl@3"
  depends_on "pcre2" => :no_linkage

  def install
    # Remove bundled libraries
    rm_r(["minpkg/vendor/openssl", "minpkg/vendor/pcre"])
    inreplace ["minpkg/lib/min_crypto.nim", "minpkg/lib/min_http.nim"], /passL: "-B?static /, 'passL: "'
    inreplace "minpkg/lib/min_global.nim", /passL: "-B?static (.*) -lpcre([" ])/, "passL: \"\\1\\2"

    system "nimble", "build", "--passL:\"-lssl -lcrypto -Wl,-rpath,#{rpath(target: Formula["pcre2"].opt_lib)}\""
    bin.install "min"
  end

  test do
    testfile = testpath/"test.min"
    testfile.write <<~EOS
      sys.pwd sys.ls (fs.type "file" ==) filter '> sort
      puts!
    EOS
    assert_match testfile.to_s, shell_output("#{bin}/min test.min")
  end
end
