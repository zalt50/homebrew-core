class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://registry.npmjs.org/@dbx-app/cli/-/cli-0.4.32.tgz"
  sha256 "2a801ece273063ed8f71893a012b5889ae4caf2e5b19824a6049ab3d2f1876f3"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "072bbff3bc8585a5e9d7b4fabff6cf16cdc0e6ea1c99eb618be4cde8cf669647"
    sha256               arm64_sequoia: "3c4c896e2966a1e220e9d9e6d347a9c5609e4d08a2fbe0db55dec816d01f3165"
    sha256               arm64_sonoma:  "1888fff5a38ad61524ba062a60698e9babd37c3870f97157aa383c7e181917a6"
    sha256               sonoma:        "56cb1df7d1c1413878ae52bd1fec38e894923f5f0af956e42f4bd6f04be4b285"
    sha256 cellar: :any, arm64_linux:   "dba0fe606b891e2ac501faa6a036422e684d8e499984eac66479bc771f25ad08"
    sha256 cellar: :any, x86_64_linux:  "ad82e2dadfc73d7a17b77870d0202971bedbc07dc2c3e74acdc38c3842213c7c"
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
