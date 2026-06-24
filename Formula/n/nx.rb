class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.0.1.tgz"
  sha256 "0af6934f8ef6cb26c19509e9757e417371ec1223bbe49ab96f96f1c0c65db7ef"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1b57cf9817203dd0fd7602ad29a69b68a02b89a4f44879b1f38ab754205b318"
    sha256 cellar: :any,                 arm64_sequoia: "b7f477b2109b851dc9cba8acc51eaac8b8f11d0f8d54aab5cb60c65ae68a97d7"
    sha256 cellar: :any,                 arm64_sonoma:  "b7f477b2109b851dc9cba8acc51eaac8b8f11d0f8d54aab5cb60c65ae68a97d7"
    sha256 cellar: :any,                 sonoma:        "080c4820cd08cd338678ff55f7bbc5fd528c09170db65e15b2fda8d8f77f6bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff900764f1ad76e12e157c1bcd2d85d1e5f3d4f8dc7593bc9b73367834cca8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141170a6283bc032e4ce0783d5c61f05777a10a87db15b35ffd9f6d06bd0f23c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
