class Bumpp < Formula
  desc "Interactive CLI that bumps your version numbers and more"
  homepage "https://github.com/antfu-collective/bumpp"
  url "https://registry.npmjs.org/bumpp/-/bumpp-10.4.0.tgz"
  sha256 "627803fdacf42f97eef8a45bff480cfcd7914535a5b008d6c16cf8fab1972da7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "feee8f6cd971b963f615a3ff44ffe98b692213da7f1ab5d44b662448819f8a25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumpp --version")
    system "git", "init"
    (testpath/"package.json").write <<~JSON
      {
        "name": "bumpp-homebrew-test",
        "version": "1.0.0"
      }
    JSON

    system "git", "add", "package.json"
    system "git", "commit", "-m", "Initial commit"

    system bin/"bumpp", "--yes", "--push", "false", "--no-commit", "--release", "patch"

    package_json = (testpath/"package.json").read
    package_hash = JSON.parse(package_json)
    assert_match "1.0.1", package_hash["version"]
  end
end
