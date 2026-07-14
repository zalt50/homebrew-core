class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.28.tgz"
  sha256 "8c5e6c8f45bbdd9074bde1c065939bc5bc5a1b70098bd9cdfc568864fdf82b40"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "a0acc6571b80fb23d3b356344fff09dd3982b6fa7191285c4b30984cc4757111"
    sha256               arm64_sequoia: "0b5a201ea2ccbf6175b171d869999ccadc2c089ab4223eb0f030168872495972"
    sha256               arm64_sonoma:  "a864f68da817dc70c7e052d02722c89ca1d06e7deb7572bec748544f64b91f9c"
    sha256               sonoma:        "7e7747f472f3fed1ce1a0af5adebadaf0bbc1bc03e1134692b56391616fa3c14"
    sha256 cellar: :any, arm64_linux:   "8b882442ac55b2a54cf880a1774ec22820665c015441dcc3cdfd9938327e176d"
    sha256 cellar: :any, x86_64_linux:  "0c2befb08adceb64b0ee8f8de46b7553ffd6fda80f1223bcf4b9e1d3189680a6"
  end

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Rebuild better-sqlite3 and keytar native bindings for the current platform.
    # prebuild-install is blocked by the Homebrew sandbox during npm install,
    # so we must rebuild them explicitly via node-gyp.
    node_modules = libexec/"lib/node_modules/@dbx-app/cli/node_modules"

    cd node_modules/"better-sqlite3" do
      system "npm", "run", "build-release"
    end

    cd node_modules/"keytar" do
      rm_r "prebuilds" if File.directory?("prebuilds")
      system "npm", "run", "build"
    end
  end

  test do
    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
