class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.5.tgz"
  sha256 "4f3b43fb0d22a3000f0947ab78774106922e70d0e54cf18af86e6c921d2c98fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34c88bac8466308bbe40953a7c9ca088b5216bfe0562520b0c36e034cc490125"
    sha256 cellar: :any,                 arm64_sequoia: "1569f65e61b48b65ac339cf79ccba1ffe3f891ade67d9d0f2d99b7de761a36cf"
    sha256 cellar: :any,                 arm64_sonoma:  "1569f65e61b48b65ac339cf79ccba1ffe3f891ade67d9d0f2d99b7de761a36cf"
    sha256 cellar: :any,                 sonoma:        "6face432777fa2fe2c52755fe825802776fc910a763cc309af0a60b49843dec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67950d31192f457b5abe1df1203edeafee757567366567b1dce92fe36d8fa3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16bdf549f93f481a65f62a569df43c677034b83c35e6dfd24d5f3a3406853b86"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
