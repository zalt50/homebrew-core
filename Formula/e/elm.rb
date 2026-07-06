class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/refs/tags/0.19.2.tar.gz"
  sha256 "745b1edfea2f8e3b36cf6f77ae3b59fd86e8e397d427971f6d903f9fce6163a5"
  license "BSD-3-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "ec3ce79abe4bb3959d399450deb363f9b5923d9095f4004c242fc9cc82360fbc"
    sha256 cellar: :any,                 arm64_sequoia: "f58530d4c64929c2966bab949d9ffdbebf8dfebf5e3226146715412f43490a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "a1e07dfaa0dd66ac5336102fd1dba224508993c8e84a7cb9699bc77a1106060b"
    sha256 cellar: :any,                 sonoma:        "6c99fb8f3afbeaf136cda6f45534add032113307ec48aa15ca918b192b46eba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc5513922a45366dc5f46202bed2e6870cc319a9b666f49b31485b08efdfb26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aedc01216943882eec74e6a2e303e1ecae098cd7270deebe10b4748eecea59b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --jobs=#{ENV.make_jobs}
    ]

    # Following the process from the Dockerfile for building elm binaries here:
    #  https://github.com/elm/compiler/blob/main/installers/linux/Dockerfile
    # This process does not use `cabal install`
    system "cabal", "update"
    system "cabal", "build", "elm", *args
    bin.install Utils.safe_popen_read("cabal", "list-bin", "elm").chomp
  end

  test do
    # create elm.json
    elm_json_path = testpath/"elm.json"
    elm_json_path.write <<~JSON
      {
        "type": "application",
        "source-directories": [
                  "."
        ],
        "elm-version": "#{version}",
        "dependencies": {
                "direct": {
                    "elm/browser": "1.0.0",
                    "elm/core": "1.0.0",
                    "elm/html": "1.0.0"
                },
                "indirect": {
                    "elm/json": "1.0.0",
                    "elm/time": "1.0.0",
                    "elm/url": "1.0.0",
                    "elm/virtual-dom": "1.0.0"
                }
        },
        "test-dependencies": {
          "direct": {},
            "indirect": {}
        }
      }
    JSON

    src_path = testpath/"Hello.elm"
    src_path.write <<~ELM
      module Hello exposing (main)
      import Html exposing (text)
      main = text "Hello, world!"
    ELM

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_path_exists out_path
  end
end
