class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.15.3.tgz"
  sha256 "cff7f0ed81aaac8b502474b52764efac1568520fa4b45144d52928fa52386524"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8ef1b1d4dc806b8e9ff40472b438a579d782e8aeeb03a1e3bd03383ba94f1bd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run")
    assert_match "Packages with issues found", output
  end
end
