class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https://github.com/mapbox/flamebearer"
  url "https://registry.npmjs.org/flamebearer/-/flamebearer-2.1.0.tgz"
  sha256 "35ebda2a2a30e954f7732098f67d215b7ccadf5a0672f631ed8b7e0277c6c624"
  license "ISC"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fa4b1af3c1cbdce03df418410f78ada2b106c7383539b2f7a9e5183ba2b75b71"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"app.js").write <<~JS
      let x = 0;
      for (let i = 0; i < 5e6; i++) x += Math.sqrt(i);
      console.log(x);
    JS
    system Formula["node"].bin/"node", "--cpu-prof", "--cpu-prof-dir=#{testpath}", testpath/"app.js"
    profile = testpath.glob("*.cpuprofile").first

    assert_match(/samples:\s+\d+/, shell_output("#{bin}/flamebearer #{profile}"))
  end
end
