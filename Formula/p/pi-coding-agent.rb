class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.5.tgz"
  sha256 "cb00c2bd12b5f97f1389aadf5661aedeeda9983614fd2fcfae3a7b18fa453b1a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e64af381095d05fc199dd935b3c92e0a3bdf882a660fb1b7f9ec4bd7a1dda9b8"
    sha256 cellar: :any,                 arm64_sequoia: "08c8a87fdd953d69ee67d1f4e2aaa9af75b755c187fe66a0f2dcadfbd97e4ec9"
    sha256 cellar: :any,                 arm64_sonoma:  "08c8a87fdd953d69ee67d1f4e2aaa9af75b755c187fe66a0f2dcadfbd97e4ec9"
    sha256 cellar: :any,                 sonoma:        "0eb62b5e616f16a9556da38e6d7a267db5dbdf10aacea8a400c56d00886fa135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67435f22ab65189961d5996784bfee57b5fdb3485d012cb7b2153591ac2b2951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8dc65157c290c0a82f067c5d6d2981b7366f7bbf9681dda7134475dcef590dd"
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
