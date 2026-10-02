class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.21.1.tgz"
  sha256 "59538fbf55a74e3492d8b66595af0662878b9fa3b6f114564ebe325211cb7932"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4183f081e9a37e1b6c17644f7ae1cb845cba6d730c7cb722dfcf42b04e73f376"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a363bc7f1384ebf8a930924179035c56e1de2ba388e39d4cfa54a1303c9263d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a363bc7f1384ebf8a930924179035c56e1de2ba388e39d4cfa54a1303c9263d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a363bc7f1384ebf8a930924179035c56e1de2ba388e39d4cfa54a1303c9263d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4906d77c5e089f5fa0781a627f40c67876f4b7f1d561e97e06629e62d6f319f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d4906d77c5e089f5fa0781a627f40c67876f4b7f1d561e97e06629e62d6f319f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
