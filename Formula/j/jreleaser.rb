class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.25.0/jreleaser-1.25.0.zip"
  sha256 "7c086a384e509ae30ad12ce2f10946601c0798e746d06a5538afc267e398644b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6f6218dd3e0dd00b8ecb9a67ac313a9c186c822eac9352bfe5f92a812b1e859"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"jreleaser").write_env_script libexec/"bin/jreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}/jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}/jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath/"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}/jreleaser --version")
  end
end
