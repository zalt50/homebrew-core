class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.13.2.tgz"
  sha256 "f55cb023afca8ec4dd912b5ffae86c9d68bf24d17ad1cf750451627396b92297"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9cc46127d5bde83f449363478eb4d7cec99820ba663f95cfda02c0987fe43e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9cc46127d5bde83f449363478eb4d7cec99820ba663f95cfda02c0987fe43e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9cc46127d5bde83f449363478eb4d7cec99820ba663f95cfda02c0987fe43e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50a3b7d70413318d782e331c9163c3f0f77a9c86b47d6ee9aa346456523f899b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "50a3b7d70413318d782e331c9163c3f0f77a9c86b47d6ee9aa346456523f899b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
