class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.143.1.tgz"
  sha256 "c8263c8d6a27d6d6b0eeadd9d5c13859396bd4f997666a26dba5ef2fcea78172"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e4a5610fb7bf08c1dbd90f5d2786012faf3c0aaf763b3137dbd8719d06ecfb8a"
    sha256 cellar: :any, arm64_tahoe:       "e4a5610fb7bf08c1dbd90f5d2786012faf3c0aaf763b3137dbd8719d06ecfb8a"
    sha256 cellar: :any, arm64_sequoia:     "e4a5610fb7bf08c1dbd90f5d2786012faf3c0aaf763b3137dbd8719d06ecfb8a"
    sha256 cellar: :any, arm64_linux:       "fa47d0a5d77c35d6dcda4dfcf2ad9fc635f544d9eb49cd11e84a4290c821de27"
    sha256 cellar: :any, x86_64_linux:      "05d5b2cb663d781a758ac391d9ac67f8b390086a532f069ae58350f697c28c49"
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
