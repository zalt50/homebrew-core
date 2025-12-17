class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.3.0.tgz"
  sha256 "81714c4ac547e73ddbc6b77af45905a1bdc94270b3d87be41990ac5b39e62781"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccf77128612423f48cd5d6e23b5ee2b68da5313356a7c67e618529b265b15c4a"
    sha256 cellar: :any,                 arm64_sequoia: "5636e9935a69ec2a4c68dd0b381f5d1b434b582eb21d174d8e99c57ccfa0df4a"
    sha256 cellar: :any,                 arm64_sonoma:  "5636e9935a69ec2a4c68dd0b381f5d1b434b582eb21d174d8e99c57ccfa0df4a"
    sha256 cellar: :any,                 sonoma:        "9da3b342b4f0e5d0e0aa996b5028c442f55172b4bc51ce236868948250495035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3281fea70861fb97774733ae61816ed0a9d9afd50ab4d9385a16ce445d2d074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5580e9d0baef8928b7efa5fa5645ac378940a276bdf169e0f59c043b9996d879"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
