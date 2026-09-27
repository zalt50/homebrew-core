class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "24a969227b9b5b8e3b9420ef00315761a9a91fd22936de52f1e94951c5016653"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a50bed851a7e01edacdc4c586aa8685c59c6afcea79bdc31cc7588cfe7a0d8b0"
    sha256 cellar: :any, arm64_tahoe:       "c44e3b6978e397ef7abab2df05a7473f9b0650e4b8d450431ff7d1ec807b9b15"
    sha256 cellar: :any, arm64_sequoia:     "ec386121fac384fccdc01ef627fa9fcb2977a3747ac3bd9bf6b938a6ab1ac9bb"
    sha256 cellar: :any, arm64_linux:       "523acc655532681ded3dcf13586a2614f2c219d9edf375d4e1efa8481d45e092"
    sha256 cellar: :any, x86_64_linux:      "029e6a5b6632dedf96854ed3ef5643efd9c2c8b3bd613b18bc2317a32e483fe9"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "shards", "install", "--production", "--skip-postinstall"
  end

  def install
    system "shards", "build", *std_shards_args
    bin.install "bin/noir"

    generate_completions_from_executable(bin/"noir", "--generate-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    (testpath/"api.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/hello")
      def hello():
          return {"Hello": "World"}
    PYTHON

    output = shell_output("#{bin}/noir scan --no-color . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end
