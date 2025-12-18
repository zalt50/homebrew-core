class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.19.1/flyway-commandline-11.19.1.tar.gz"
  sha256 "9c8dde89570270c4fd145f205024f398ec2396d502185c1db8482b787098a4be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac6d92b0170f93a3aeecc898f73c21a4d5ddf346e4c2f1672dd1bfd84d4124b2"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end
