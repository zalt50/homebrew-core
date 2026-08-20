class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.103.0.tar.gz"
  sha256 "9b99292e9833ba9908c34d53dcbe62866d4825f52d28af5aeea03803c9696cc9"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff74e9975748897dfe66a85ed3500ee8da00e3372d4e201a7cb9bdddad122723"
    sha256 cellar: :any,                 arm64_sequoia: "fe89026b2049aa2ab2a3b1f6beae03b90772366737c0e5a5dda225aae41e761a"
    sha256 cellar: :any,                 arm64_sonoma:  "fb79d3ac77d327d420fb7b37faf6504f779398b4131d665c221f6306ecd06d8a"
    sha256 cellar: :any,                 sonoma:        "892c81ee215fb20667d4e17a5197099472029f65add86788639e2e778003c11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7033e4fee95bc602ece8869c36bb3072b219dedc208bb343d88484e8b3e9527f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852a8efa60abeaa49eac6a609f31743203af56b32130020fa50b177135c882d2"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"

    livecheck do
      url :url
      regex(/embedded-protocol[._-]v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    (buildpath/"build/language").install resource("language")

    system "dart", "pub", "get"
    with_env(UPDATE_SASS_PROTOCOL: "false") do
      system "dart", "run", "grinder", "protobuf"
    end

    args = %W[
      -Dversion=#{version}
      -Ddart-version=#{Formula["dart-sdk"].version}
      -Dcompiler-version=#{version}
      -Dprotocol-version=#{resource("language").version}
    ]
    system "dart", "compile", "aot-snapshot", "--output", "sass.aot", *args, "bin/sass.dart"
    libexec.install "sass.aot"

    (bin/"sass").write <<~BASH
      #!/bin/bash
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end
