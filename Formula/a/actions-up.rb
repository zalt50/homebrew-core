class ActionsUp < Formula
  desc "Tool to update GitHub Actions to latest versions with SHA pinning"
  homepage "https://github.com/azat-io/actions-up"
  url "https://registry.npmjs.org/actions-up/-/actions-up-1.16.0.tgz"
  sha256 "26c3ea5750a0fad9ea58923fb789c43f72b485c4414ffaa66ffc34a4ca7bb07b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6e14e0996624dca26204f76cc9ab5ee9e0f4628d1b2faf1c0572d595c3f9b40"
  end

  depends_on "node"

  deny_network_access! [:postinstall]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actions-up --version")

    test_file = testpath/".github/workflows/action.yml"
    test_file.write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    begin
      output = shell_output("#{bin}/actions-up --yes")
    rescue Minitest::Assertion
      # Ignore GitHub API rate limit errors which are common on CI runs
      assert_match "⚠️ Rate Limit Exceeded", shell_output("#{bin}/actions-up --yes 2>&1", 1)
    else
      assert_match "Updates applied successfully!", output
      assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, test_file.read)
    end
  end
end
