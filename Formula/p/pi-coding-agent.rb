class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.80.6.tgz"
  sha256 "2a77634640b2d86d90d24087bb67559ecf2366e0fb52a42c55eed416147da411"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c524bca8d51f31de036b05b94b4564390b1165b18682a512d54d7246e3e096c"
    sha256 cellar: :any,                 arm64_sequoia: "68faf429a6c9385d1eb7958887485e927af1e9f4ddf30e8b297306975e7b7abd"
    sha256 cellar: :any,                 arm64_sonoma:  "68faf429a6c9385d1eb7958887485e927af1e9f4ddf30e8b297306975e7b7abd"
    sha256 cellar: :any,                 sonoma:        "0353042ddba808dfd9abf469266b445cbd3e305033164204c362ef6c7fa8aff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c2e9712dda8ce9e8da3c20eeda1b83cb92495e2f9d4b2cbe0e5e5632a21143b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f6f7d2c3f62f45ae360ec7012191152cfd353acf6954486d66df714aebf882"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: 1

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
