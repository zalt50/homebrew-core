class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.80.1.tgz"
  sha256 "76bf497cd15cc13d3a4beff2902f9850c8aee93eec57b893371fa51ed345ab5b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6a05420c00ebd700156397e01437c0e39a85ee367667be4da92f38e05438da2"
    sha256 cellar: :any,                 arm64_sequoia: "5a84a42790a203c4d24540f1e1cb54e8a29fbda41046283f4321676b2b3f2273"
    sha256 cellar: :any,                 arm64_sonoma:  "5a84a42790a203c4d24540f1e1cb54e8a29fbda41046283f4321676b2b3f2273"
    sha256 cellar: :any,                 sonoma:        "9d90222e5821973a7ee734687433c462f2b1abf46e37f898ba5d7aad6a692c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80212bf633d87c8aa1062aeb8867ab3435a5cafb8797113c20a468a0661d9a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba9de15ccc561c95a3fc91c70d775887ba68f61f4f50e8a3aa6e7d4d31ffc8d"
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
