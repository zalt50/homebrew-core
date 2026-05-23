class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.7.0.tar.gz"
  sha256 "ff2c154c400a8893b332f9f87b45b7300e5b2071f0e54b69da8c692b58fd86b1"
  license "Artistic-2.0"
  head "https://github.com/cph6/zsync.git", branch: "master"

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a6472a6c5db07355418baa9806763ed9c042f91c15a5df87ac2b6c59becbc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c591c6cde4e285d18d3c63952b55ab4b81fcc3d25b4920c57be4edb416550d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1475d54229d78f6a6ea23479ea2df033d9a1f838237c1bfd81d57d1b34328600"
    sha256 cellar: :any_skip_relocation, sonoma:        "e42a2e9acd88b9889d6ae579ef334cf20f7380962da450d226f9f41c44582f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a991cbdc03c6fb9c7a1114802fb5e151f0440ebe1c8173d6f2c178b56ea5eea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f85547fa385ae58296367abbf2b01816514315f54ef3f41fc387e1c41263a4"
  end

  depends_on "go" => :build

  def install
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/cmd), "./cmd/#{cmd}"
      man1.install "man/#{cmd}.1"
    end
  end

  test do
    touch testpath/"foo"
    system bin/"zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_match "SHA-1: #{sha1}", (testpath/"foo.zsync").read
  end
end
