class Ni < Formula
  desc "Selects the right Node package manager based on lockfiles"
  homepage "https://github.com/antfu-collective/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-28.2.0.tgz"
  sha256 "7f03ce8e7dd309ea9642b264576c18d8753bfcb6fb8a2c4a858a915b52e8595c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c29671f4ffc430f1c0f5285ab4d1f2330ee82a37d9be494273352a425516993b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"nr", shell_parameter_format: "--completion-")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "fake-package",
        "version": "1.0.0",
        "description": "Fake package for testing",
        "license": "MIT"
      }
    JSON

    (testpath/"package-lock.json").write <<~JSON
      {
        "name": "fake-package",
        "version": "1.0.0",
        "lockfileVersion": 3,
        "packages": {},
        "dependencies": {}
      }
    JSON

    assert_match "up to date, audited 1 package", shell_output(bin/"ni")
  end
end
