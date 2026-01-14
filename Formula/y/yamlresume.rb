class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.10.1.tgz"
  sha256 "e1027e3b61e19853674f9db52eb8acdc94be28ea93d8cb0afe9924d8e39604d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e744e6b308562a288b95a69f7cb30f39858e2520f91b635578da7a234dfbc20a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
