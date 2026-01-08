class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.2.0.tgz"
  sha256 "17de9a7f32ee38dbc2dc6776891ccfb19a678e692b309c00adc70e7584641f52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85dacb42136470b18604612816fa7986c54bac1fffed3f9f81c35353e6e20c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88fe74cc35ac1ce5938de007d7213abecf6ee9d86343be28cddcab5e0958e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88fe74cc35ac1ce5938de007d7213abecf6ee9d86343be28cddcab5e0958e9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "65550cf8a725e9fb9a59b7c55fe42c0a0a588d4d2fdcaf8a171861376b554299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f7efc89bab98a9bae44d9b983a53da08fac9c1f0c8d9ff0c43e6d1a5503b7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f7efc89bab98a9bae44d9b983a53da08fac9c1f0c8d9ff0c43e6d1a5503b7ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end
