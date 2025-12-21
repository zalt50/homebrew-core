class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.9.0.tgz"
  sha256 "01133e934005131cdee1a31db3bfeafe623ed481abcc645034c8d296f4a33440"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2000ae710f694301ed939f1f811493fd2713afb038aa4e22f0bdc6a5309e4cad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
