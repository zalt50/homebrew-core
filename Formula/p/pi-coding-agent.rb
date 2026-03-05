class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.56.2.tgz"
  sha256 "5e6a2454dacbd459becdf7c552927e6b4e4eabb8862d85771cb7b9384f633559"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e7ecab48f4753c70791bdbbcbddafd608e4bda3f0a54e4db95a6e2e5a82a793"
    sha256 cellar: :any,                 arm64_sequoia: "f4d4fc5a23a971c968999e03a45cce72354ce823acdf792da9ac6e1aff09935c"
    sha256 cellar: :any,                 arm64_sonoma:  "f4d4fc5a23a971c968999e03a45cce72354ce823acdf792da9ac6e1aff09935c"
    sha256 cellar: :any,                 sonoma:        "772093920a02593f2442cbd6c4cc27b4f09b9eae440e4ffd63932fff44bcc248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e870cc6708918bfee6a61620125aff16a5cdd203350b64422d71bda127747b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd2c17df518b421b254b50cbc5a20bb31bbc735fc9f31ba7f97824c1a1ab48b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
