class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "408646496895753608ad9dc6ddfbfa25921c03c4c7356f2832a9a63f4a7dc351"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "a3f8a2cb4563008ea24c54345240b6c92553291c12860425cc069903ef4e484a"
    sha256 cellar: :any,                 arm64_sequoia:  "8a85e164420eed7be9149784ed3186c27e475ac4249396bf7cab23d0cbb9d612"
    sha256 cellar: :any,                 arm64_sonoma:   "a5ec87e6b0b78f8f9c7488ee60fba66fa32b820ad0beb17a2a2ad609cf0db4ef"
    sha256 cellar: :any,                 arm64_ventura:  "18491874794e510a5ceab9f85b056dd5338869c63d6590bd8d2e5e5eb451e081"
    sha256 cellar: :any,                 arm64_monterey: "97ada88c358d6b8fee6731bc2fb5a2b6f869ff0d9798b831801aa16096db0e40"
    sha256 cellar: :any,                 sonoma:         "080ae8f329e1f5434ff565a2731066510251e94be46b3dbc88ce81d7fa131395"
    sha256 cellar: :any,                 ventura:        "bfd55cd5a7c527f3ee97be03d31019f19bcc42e8827eff660a3e0225fc010601"
    sha256 cellar: :any,                 monterey:       "a131b4cca2eb06a0077955ad754e0cf2e028b6edcb8d59f671d3863f4d0c9e09"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0fda47994e673c1315f52cde8615be23dd6cdf870982562aa2cc7a09ae44c8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f4a8c2fa4c22f00887c45852b4fe5326d1df941f484f5884bf5cab6df1c81a"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"

  def install
    inreplace "build.nims", 'targetDir = getHomeDir()/".arturo"', "targetDir=\"#{prefix}\""

    system "./build.nims", "--install", "--mode", "mini"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
