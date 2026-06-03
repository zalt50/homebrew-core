class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.4.0.tgz"
  sha256 "b0ed5b14e3ff20ed45e1f7b5f1a37c847db437386b5fa2c98097fff8a0537f78"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25a8e251b633969c788ec4c66ebaff45127a2423774cb1ca3013c84f0de0e302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25a8e251b633969c788ec4c66ebaff45127a2423774cb1ca3013c84f0de0e302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a8e251b633969c788ec4c66ebaff45127a2423774cb1ca3013c84f0de0e302"
    sha256 cellar: :any_skip_relocation, sonoma:        "33527abf7c8531aae11ce4fa172a05b8f4cffec93ffaf3e0acc9334337e66b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33527abf7c8531aae11ce4fa172a05b8f4cffec93ffaf3e0acc9334337e66b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33527abf7c8531aae11ce4fa172a05b8f4cffec93ffaf3e0acc9334337e66b38"
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
