class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://docs.basedpyright.com"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.39.10.tgz"
  sha256 "11891e35fb3afcde55d5f358b147ec99be13ee1eb8ea5db893db430f51eb5b2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "330d920dc89d0559699dc813628976f7f0a34e6f6780ff6831c8e1bec763cd47"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"

    # Remove empty folder to make :all bottle
    rm_r libexec/"lib/node_modules/basedpyright/node_modules" if OS.mac?
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
