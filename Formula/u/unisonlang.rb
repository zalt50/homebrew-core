class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison/archive/refs/tags/release/1.3.0.tar.gz"
    sha256 "9a9c53fcb7a6913504d3356b5661eae33c28271d6253fd5cb08cb5e93bd67295"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.3.0.tar.gz"
      sha256 "80e097c82b6a38f16d3c3b42463c331e3e63f4d39f4360d894c82dd447237bee"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(%r{^release/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98936d34a386126a0aa4fc9a31deee125d8fb4614c1efa1259a3612551ac2358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2190617e7ee4b96e657a8f462c2ed74620eddc40a6488a8a621c19ccb2df7df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ec40311e5cd29dcd4dbdf797e1f895991926938c73377e6379770a67d6956b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "28d7f7349b8ef6e04d2cc5e294aac0b45864b527fdbb8811406288383cbc2813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9fd6b7a209f23f16e66159d9fc823f9f74bf209c7d08239a1bb2089fd5404b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737989266a2649eeac5e8698e6fa0cb50a68043c2766ab577434664eccba6558"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "elm-format" => :build
  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      ENV["npm_config_ignore_scripts"] = "elm,elm-format"

      system "npm", "install", *std_npm_args(prefix: false)
      # Install missing peer dependencies
      system "npm", "install", *std_npm_args(prefix: false), "favicons"

      # Wire the real binaries into node_modules
      ln_sf Formula["elm"].opt_bin/"elm", "node_modules/elm/bin/elm"
      ln_sf Formula["elm-format"].opt_bin/"elm-format", "node_modules/elm-format/bin/elm-format"

      # HACK: Flaky command occasionally stalls build indefinitely so we force fail
      # if that occurs. Problem seems to happening while running `elm-json install`.
      # Issue ref: https://github.com/zwilias/elm-json/issues/50
      Timeout.timeout(300) do
        system "npm", "run", "ui-core-install"
      end
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
    end

    stack_args = %W[
      -v
      --system-ghc
      --no-install-ghc
      --skip-ghc-check
      --copy-bins
      --local-bin-path=#{buildpath}
    ]

    system "stack", "-j#{jobs}", "build", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
    (testpath/"hello.u").write <<~UNISON
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    UNISON

    (testpath/"hello.md").write <<~MARKDOWN
      ```ucm
      scratch/main> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    MARKDOWN

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end
