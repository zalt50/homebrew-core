class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.59.1.tgz"
  sha256 "f38eb0e278dc0c56873d138aadb0a12e4c03aee8d567163f71fc4a30d393d5f1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e37b102883e704740970aecb5e2e67a46d1317d6d3f50daeee9f5ec2bf9e3480"
    sha256 cellar: :any,                 arm64_sequoia: "664a6c877ba9863fa8452a111137d3a70a3a5282dca690f0ab373ad613c50cc9"
    sha256 cellar: :any,                 arm64_sonoma:  "664a6c877ba9863fa8452a111137d3a70a3a5282dca690f0ab373ad613c50cc9"
    sha256 cellar: :any,                 sonoma:        "f870443cc1fa2430d0392d176713fb4bb7920d7e4c2601e9fc0d438f70020c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f8f877fce1885bd938892850878c2f53ca1f11a343e77e6655a7a47057d0e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23877f42b5c45d3fb634aa94b8237cd10ec8daf4fad99572bd9bfc08e4c5d67a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
