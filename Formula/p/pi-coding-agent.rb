class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.78.0.tgz"
  sha256 "a047da75801d9135e368a4711d06d0ca4b6ab708801ab82fd1366dde1eedd0ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a92196914d4a9490c5b83d94222d0e6c4e3018431902678fee6dff9b1ea7c3cc"
    sha256 cellar: :any,                 arm64_sequoia: "8267edae450765262d02f3835da166e896cd1ed09e2419be943a6434fc9ec676"
    sha256 cellar: :any,                 arm64_sonoma:  "8267edae450765262d02f3835da166e896cd1ed09e2419be943a6434fc9ec676"
    sha256 cellar: :any,                 sonoma:        "450fb74eb903658dd758407e5d70acb0fdf1a96b606823d43739a11cf696a551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0531c21b2a145d6aa1546019aa0a2f59ae868262d483077507b9b573906f1ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39343932fd0eda4e6ba16c44d581663122c5a7cbebd5319977b4f12179edab8a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
