class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.1.0.tgz"
  sha256 "bd0ceeb80b87e61ce263419402ef01812502a774b3661cfb10f8b19102c9f015"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a952e3bf3ae4444be49ac0421cfef6eec946dc4aefac79908f25394bce6e501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d44c67dab22651d5a9120fe43a9fdcb4fa9ccaffd62473a50dac686f24daf13a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44c67dab22651d5a9120fe43a9fdcb4fa9ccaffd62473a50dac686f24daf13a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a24c9cdda7c70d8411575017c988e0ee6489d1a883b09e2a9d77c60f2b1a66f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a972adc79b27c91bc89a56c3079393f0d9ecc46598af6e7b3039aa60bcfd696b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a972adc79b27c91bc89a56c3079393f0d9ecc46598af6e7b3039aa60bcfd696b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
