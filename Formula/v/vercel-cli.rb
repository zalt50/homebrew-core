class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.8.0.tgz"
  sha256 "23ae71376fbf1599acdbfd507f2f4d80065ef638b03512dc05d43d8678cdb474"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5ba6411bcb87de91a634b4fa94d69c2c71a4940496e3e679eda01aed92e924c"
    sha256 cellar: :any,                 arm64_sequoia: "b54d476bfafcbe68e96f9e309cb5d6ae611c617e7464b3e4debc94b2556e209d"
    sha256 cellar: :any,                 arm64_sonoma:  "b54d476bfafcbe68e96f9e309cb5d6ae611c617e7464b3e4debc94b2556e209d"
    sha256 cellar: :any,                 sonoma:        "a35323697d6b32eca0c26ea93ea0be112afc468b3ec989a691b69b59183708b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a11857ca5d714fc02cb376bbd2c6ce21ab4c7dbbee717b612b61c8f95137579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5db7adb51e630ef40aa04f06dfd82b64a9e8aeb7dcd0c3397233a968b3a05e6"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
