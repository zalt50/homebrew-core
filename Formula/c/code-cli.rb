class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.123.2.tar.gz"
  sha256 "2ae06fd7bc599aad5fad41d530cced9c997e185328ff9eb91011470f111a6c28"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "993194bff40e80cf19769f98a3c89ffc4eb4570df0cc9959e05436f149d89370"
    sha256 cellar: :any, arm64_sequoia: "ebb96a28609f0ea92519d6e0283b3b42c2d590c7157b9f5a5af297b8ed771c0e"
    sha256 cellar: :any, arm64_sonoma:  "23a944c3107e31a6f5ecc857549ec74a7517655bee809d264d8b6d9f43dd13d1"
    sha256 cellar: :any, sonoma:        "7e13f7b4a8fa67095c73d670755f3f98e2c96f72ef895ae97c99abeaa3a04763"
    sha256 cellar: :any, arm64_linux:   "dc6d653811e1dc3fe66ff3047d40d582cfaaf1d054b9a672fc2cae8723770c7c"
    sha256 cellar: :any, x86_64_linux:  "8f22d4f8474dc9574eb0ca4b6c65f6ce77ef74ee24106901000b72b2a25de0c2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
