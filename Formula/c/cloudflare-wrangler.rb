class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.134.0.tgz"
  sha256 "0161f9532b530609de5bcb84643ac6e25afcf76496e53c3049afbe1bedf10acc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "adce96f7e8318a882d676f90694b7edd9dd06035ffa2899dfe4d558349a5e273"
    sha256 cellar: :any, arm64_tahoe:       "adce96f7e8318a882d676f90694b7edd9dd06035ffa2899dfe4d558349a5e273"
    sha256 cellar: :any, arm64_sequoia:     "adce96f7e8318a882d676f90694b7edd9dd06035ffa2899dfe4d558349a5e273"
    sha256 cellar: :any, arm64_linux:       "b8a6bea1efab973292a355d3d005bfc6db17850e1b2ca77a375c95ddc0f8772e"
    sha256 cellar: :any, x86_64_linux:      "b7dcb34b66f3110238176e442e34f27fb51e76caf3a4d47ca616ee76383dd42e"
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
