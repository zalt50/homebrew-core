class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.20.0/flyway-commandline-11.20.0.tar.gz"
  sha256 "845cf6fdf4a1a104d210f39d9ea4980d47f268ce9c58b5944e3fe2eef66419f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3c17fc7fbb407daed093799f883277f49187a981b62ce43a3f7b72976ff4a81"
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
