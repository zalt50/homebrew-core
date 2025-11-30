class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.82.tgz"
  sha256 "5c576b77c6ede6decd35f172e761af695c4d2f7fe1c9bdb816631e1d8c0e053c"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41436c29a4665958f28a894c089416172431d55f781ba6211901e97de4a177a8"
    sha256 cellar: :any,                 arm64_sequoia: "d226c087bc29796c3d6fa3064f93c7afd0b547b274dc7facaefa4102437462e7"
    sha256 cellar: :any,                 arm64_sonoma:  "d226c087bc29796c3d6fa3064f93c7afd0b547b274dc7facaefa4102437462e7"
    sha256 cellar: :any,                 sonoma:        "000953329ce9afabd28ab3de15ee079a3f6e0f36bbdde017d95d9236e8c9f30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5fe4834fec519d47a46ae1dd53bce11a4403b783bb8df10c8c810b1fdc8476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7237877d2337be79ddfb00999acd2aa3e02ac17ba8d46e07fa812930e0507bba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/yuque-dl/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
