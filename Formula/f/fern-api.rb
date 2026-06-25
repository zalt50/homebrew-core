class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.54.0.tgz"
  sha256 "5f0c139a0099e1c14d72f9a1a35b590eac4f1377e6e5b5a1a8bbd88470dcd2d4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b0cfa8f4b2ca30d804a28e1c59b58eaafdc9c663a4189f5ea55686711087ad2"
    sha256 cellar: :any,                 arm64_sequoia: "3da8f48b9e4b6296c8f69a455316e41fa7bf6e6da25680ac064cb5f83f24925e"
    sha256 cellar: :any,                 arm64_sonoma:  "3da8f48b9e4b6296c8f69a455316e41fa7bf6e6da25680ac064cb5f83f24925e"
    sha256 cellar: :any,                 sonoma:        "b69954c6da7cb7e470e160e52cd632e41b1cee4c92dd54893f06bb6f832a98ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "134c2017cfaf7096683b0ffaa87c9d0da5e1c3f0ff59997551b1e67e7e0b1b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da8f582ae3c663a1999c07eac9873df5fe5fcefc10c4babe82db3cf98b794db"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
