class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.2.6.tgz"
  sha256 "a46f01eb42f7f444b447d1e78eb773e29d133870d12e9e6de613f46acad34bcd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c816dc2fff7bbccc9fc847ea93326c8f926046712e14e79b527aff305fd3efe"
    sha256 cellar: :any,                 arm64_sequoia: "79d69aabc6037847c1c0cc229d7505895a95e2f994ee69692537176bdab29227"
    sha256 cellar: :any,                 arm64_sonoma:  "79d69aabc6037847c1c0cc229d7505895a95e2f994ee69692537176bdab29227"
    sha256 cellar: :any,                 sonoma:        "c8b3c9216443e37cc2e79c4092422d55e1129697c804c7c6cc4c77e68ed6aacb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86c3bd848b076b2bfa406c12bfb0afa4fdfc96abf877c9042a92ec37bf52c64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d11136d94f43bfb271b4c426accd5b7eae20847203d19d372e96ac0bf011764"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
