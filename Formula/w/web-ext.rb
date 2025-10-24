class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-9.1.0.tgz"
  sha256 "de34d5e83a75de907549b5e87d37cc81c36bce896f8183afdbbcaee687a08aa1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc8e2cfba9abf8dca39f8421afe6cc91185721bb0bd323247c5d17b2f3e482df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8e2cfba9abf8dca39f8421afe6cc91185721bb0bd323247c5d17b2f3e482df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc8e2cfba9abf8dca39f8421afe6cc91185721bb0bd323247c5d17b2f3e482df"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8e2cfba9abf8dca39f8421afe6cc91185721bb0bd323247c5d17b2f3e482df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22c036990df5fa2e7c90c4e21e5dd31f7decc3651483663af6523c68acd65ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c036990df5fa2e7c90c4e21e5dd31f7decc3651483663af6523c68acd65ff4"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/web-ext/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    JSON
    assert_match <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        2

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
