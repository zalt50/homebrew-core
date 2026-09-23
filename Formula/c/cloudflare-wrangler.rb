class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.136.3.tgz"
  sha256 "306f2483ff7133cd3ef12e045e56fe22fe7fad30772274e1556b7de2b56eae0a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6dcd0c35d8e39852f4e504add9cea90b9a252d180432d74d7ef07d4fb414271b"
    sha256 cellar: :any, arm64_tahoe:       "6dcd0c35d8e39852f4e504add9cea90b9a252d180432d74d7ef07d4fb414271b"
    sha256 cellar: :any, arm64_sequoia:     "6dcd0c35d8e39852f4e504add9cea90b9a252d180432d74d7ef07d4fb414271b"
    sha256 cellar: :any, arm64_linux:       "cc58ad2d0b05b829f25e9034b2e7c0534980937c10313fc4cf81de3e05d55965"
    sha256 cellar: :any, x86_64_linux:      "5952feeb822a267d094d542c093726bd2c50c04761ec1c109b52ef2f4d0c394d"
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
