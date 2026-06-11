class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.46.0.tgz"
  sha256 "0f36bcd29dcb69ac484427fad57006579b4b559f4b36ecbf893e9f960e1bbc40"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "8752ebcdc9ea60125274f861b00799771436d53f2df3c68669b9e72f3fea3d1b"
    sha256               arm64_sequoia: "62d5975818ba78a54021ba87e46ab55a0aa2745cf32f91bf6d16bf85005f7185"
    sha256               arm64_sonoma:  "1290ac2ddd6a6661da484300625b194cac61f20cad72e39b16465c8f616286cd"
    sha256               sonoma:        "73768b860c32bfa8a8ea39e468b85a92ac1e0ad5c96f16c9e929c99655971223"
    sha256 cellar: :any, arm64_linux:   "56962d3a1af42423a7cb1a9f68cf1c3eb456576ddc20b318b150150cd9846ca0"
    sha256 cellar: :any, x86_64_linux:  "bb2c189ed9ce63172e65d35a130d2fa8210d8ead21b9a12c5e3faaad4e967814"
  end

  deprecate! date: "2026-06-18", because: :unsupported, replacement_cask: "antigravity-cli"
  disable! date: "2026-12-18", because: :unsupported, replacement_cask: "antigravity-cli"

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
