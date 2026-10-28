class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "4749822d6561690c37ba45c56b81582979798ae93acd704b850b834ca6b73c02"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ac8cc23fb20f8972c1c31ef714ec284c5347c65d1b5b1bea043fbbf1c352b6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82e399d7d9876840a2334309d55e904bec01dff74f5fd86a2bd7d30b7f7740f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3c8970d9abdba0a7e100f6ae45ed5325b6ec429bd0fcc75782b1eb78523b587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0c82df7e66a65bc359d66c22f11751bd006ddf555691d1e46619a0fcecec8374"
    sha256 cellar: :any_skip_relocation, sonoma:            "05cf09761faa012a9cbde46d0b435893761a83035fa79d6992b8618f28719647"
    sha256 cellar: :any,                 arm64_linux:       "cae4fe3c6154c7cf0239084ac09891f2bcb047a89dee11b0857abd4cede817fe"
    sha256 cellar: :any,                 x86_64_linux:      "5be7cb1d077249375566c0efdd4bbb9768b5a169958956cef223aaa8598409c3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"gitu", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    # `--print` renders one frame without setting up the terminal, which hangs without a TTY
    assert_match "No .git found in the current directory", shell_output("#{bin}/gitu --print 2>&1", 1)

    system "git", "init", "--initial-branch=main"
    (testpath/"README.md").write "hello"
    assert_match "README.md", shell_output("#{bin}/gitu --print")
  end
end
