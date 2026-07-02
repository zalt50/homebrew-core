class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.stargrave.org/"
  url "http://www.goredo.stargrave.org/download/goredo-2.9.2.tar.zst"
  sha256 "b15cf99b6d11e586223f24712d90d739e6e115abe4b423d26da9412b90339f41"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.stargrave.org/NEWS.html"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39594646d5886a2fed9a3574dd80ee2269c37a653962338a5bc013907b8c2be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39594646d5886a2fed9a3574dd80ee2269c37a653962338a5bc013907b8c2be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39594646d5886a2fed9a3574dd80ee2269c37a653962338a5bc013907b8c2be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b978e1253e230cea88f12e5a6a30e29b051b552fda6d739939bc3b6ba1faf4ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0951d98cb61b0d9da7152f5209c06100b17a9d6677b8647444ecdd15ff481f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaed3d7c4a251b26f67767ba92951a43ed1f89f5414fb25b9ba781d5c96cb5bb"
  end

  deprecate! date: "2026-07-02", because: "is not available via HTTPS"

  depends_on "go" => :build

  conflicts_with "redo", because: "both install `redo` and `redo-*` binaries"

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_match "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")

    assert_match version.to_s, shell_output("#{bin}/goredo -version")
  end
end
