class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.118.0.tgz"
  sha256 "e1c75e298aec20667f627ed4a838bbeef1850754e061aaf8fc6611aff522d4cf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a2a34cddbae3743b0a83f91c3a23c0df911a260be69320fcfb5e33b2788205fb"
    sha256 cellar: :any, arm64_sequoia: "a2a34cddbae3743b0a83f91c3a23c0df911a260be69320fcfb5e33b2788205fb"
    sha256 cellar: :any, arm64_sonoma:  "a2a34cddbae3743b0a83f91c3a23c0df911a260be69320fcfb5e33b2788205fb"
    sha256 cellar: :any, sonoma:        "d7d365e9e8fbef1af75e7b4b3fc2326bfe9170a377cca42544250775b53c96a0"
    sha256 cellar: :any, arm64_linux:   "559a5bcae3bda1331e52b465abc0d39cd161775fee0392f1561323ac89fdf450"
    sha256 cellar: :any, x86_64_linux:  "9af4698940bb7a932f275306027a3ecde15d263e68a2965580d32033c1c8afc6"
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
