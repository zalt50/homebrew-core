class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.105.0.tgz"
  sha256 "ff7c2074e200fc50efbdea49eb31bf1b51e2596ee858e5e2c96623ee34f0304f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "28fe7e2e670e5daa674f7540799d0d2080dab552a10ad24a289aadce58b1996e"
    sha256 cellar: :any, arm64_sequoia: "bf7f1dc20c940903691f6af764835fc907ada2ea6301b4c18bad135d83641e5f"
    sha256 cellar: :any, arm64_sonoma:  "bf7f1dc20c940903691f6af764835fc907ada2ea6301b4c18bad135d83641e5f"
    sha256 cellar: :any, sonoma:        "90afeff600b505a85cff940f2a4747cbf1cde10e6384b88b8e9960f7cc9a29fd"
    sha256 cellar: :any, arm64_linux:   "f064b2609ddd5deae132c4d1126b657fb5ecb840b3118111bf735c19e1593db7"
    sha256 cellar: :any, x86_64_linux:  "6e1c2688e7c6e0a00a1229ba758fd2e32b5106d547891c62d5d68ee1afc4ea47"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
