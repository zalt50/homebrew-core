class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-10.2.0.tgz"
  sha256 "67f0abf197b30f7180c5cd3c7ad812a9b8e913a61f497d80695c70e9e268d91c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, sonoma:        "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ab36e66668204365c0c7da1d45fff8a7c1d878d5e36d3c3cc8de5d9c94135e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab36e66668204365c0c7da1d45fff8a7c1d878d5e36d3c3cc8de5d9c94135e4"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    JSON
    assert_match <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        2

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
