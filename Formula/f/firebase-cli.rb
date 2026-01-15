class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.3.1.tgz"
  sha256 "055454edf0e3927aee5b702616ca27cb1bedae281320cb267d3cf428c32a6d89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a724615869dd85737e7309ef07643ca0f497b0f1c6bff59b5d4352c6d54e204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "651422bfa8b7be3f7dcb5b106637add24903e815317de7177e0df64d89811f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "651422bfa8b7be3f7dcb5b106637add24903e815317de7177e0df64d89811f09"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54921bf5e3f4869b1be2fc8f0bae3aaedaaab3ce779dfe14f6e2d0b0566aaf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73cd69792b97d62c76c5f1b73a5df8e7868e6f85b5ddef4d77e55f72a7b3b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73cd69792b97d62c76c5f1b73a5df8e7868e6f85b5ddef4d77e55f72a7b3b41"
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
