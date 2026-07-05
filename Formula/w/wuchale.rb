class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.6.tgz"
  sha256 "5cc7d5b7bab5d49948f8486083a69ca77a568a5e25f17d6ddcd8c3d58e1fa87f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "788c054d784d50907ab53f3e9a4c68952e4341be4c5084997d8fe51949c3a3ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
