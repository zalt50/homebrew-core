class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt.git",
      tag:      "v0.12.0",
      revision: "6221b009587c39f326b376085c931eed25f42ebc"
  license "MIT"
  head "https://github.com/fables-tales/rubyfmt.git", branch: "trunk"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d4825a2aaf18c4d14d339190e26fd6042cd2312dd1953c5844c114def6700b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df96caa4ae7cc5d2fc1f5cd0a0e9c790cc1f9fc48001fcf26c37f6162107a879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723d4db76a00d239154f8106ddfee3dd5e50557fe0221ab70c2e38a05900670e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ccdacf5cbbe5cfc0e5ec9632de656ca88120506a7cf24042b8185a0c307f3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bccac8730df069393705d544a155d731f85bec4896da35cdc2e2d1fd22e530ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5269e94181e4aff93945f2f681e29096f077b9e17fd9b470e431765e2a59491f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "rust" => :build
  # https://bugs.ruby-lang.org/issues/18616
  # error: '__declspec' attributes are not enabled;
  # use '-fdeclspec' or '-fms-extensions' to enable support for __declspec attributes
  depends_on macos: :monterey

  uses_from_macos "llvm" => :build # for libclang to build ruby-prism-sys
  uses_from_macos "libxcrypt"
  uses_from_macos "ruby"
  uses_from_macos "zlib"

  def install
    # Work around build failure with recent Rust
    # Issue ref: https://github.com/fables-tales/rubyfmt/issues/467
    ENV.append_to_rustflags "--allow dead_code"

    system "cargo", "install", *std_cargo_args
    bin.install "target/release/rubyfmt-main" => "rubyfmt"
  end

  test do
    (testpath/"test.rb").write <<~RUBY
      def foo; 42; end
    RUBY
    expected = <<~RUBY
      def foo
        42
      end
    RUBY
    assert_equal expected, shell_output("#{bin}/rubyfmt -- #{testpath}/test.rb")
  end
end
