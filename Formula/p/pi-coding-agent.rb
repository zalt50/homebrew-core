class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.75.3.tgz"
  sha256 "6992c0a32f0185126e2551ecacae782b622def9422021ba2e7ef75381b74168c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a911c14eb0a1df250c431cc4bcad5b59f3cfc249e84f5cdc16c6eb1f9387cc70"
    sha256 cellar: :any,                 arm64_sequoia: "a69439816511718f9cdc7ebfd3eb07593b526c295d3f342f0fb903f0462c3b65"
    sha256 cellar: :any,                 arm64_sonoma:  "a69439816511718f9cdc7ebfd3eb07593b526c295d3f342f0fb903f0462c3b65"
    sha256 cellar: :any,                 sonoma:        "d854a753acd9d3b610b406456e2e7cf04e10cf21ec87084d241bf7f2e200e0e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83c60c14a904f3319642e4e82bd388c3ed761237ccc06d92d3846713b776a95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a477d5a5e27a92690fb08e8153878bde238708ff01640b355946adf88bea3f98"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
