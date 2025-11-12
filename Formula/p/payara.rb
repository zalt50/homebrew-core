class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/6.2025.11/payara-6.2025.11.zip"
  sha256 "4f8248f1fc2cedf14a829dbec73768bc824c2c418d60843c30a365a6ef76f486"
  license any_of: [
    "CDDL-1.1",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
  ]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "393613c0e36b08a41f8ff9e9c3efc73ff4a27c930f0364a51e8dbe5ae65047f1"
  end

  depends_on :macos # The test fails on Linux.
  depends_on "openjdk"

  conflicts_with "glassfish", because: "both install the same scripts"

  def install
    # Remove Windows scripts
    rm(Dir["**/*.{bat,exe}"])

    inreplace "bin/asadmin", /AS_INSTALL=.*/,
                             "AS_INSTALL=#{libexec}/glassfish"

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  def caveats
    <<~EOS
      You may want to add the following to your .bash_profile:
        export GLASSFISH_HOME=#{opt_libexec}/glassfish
        export PATH=${PATH}:${GLASSFISH_HOME}/bin
    EOS
  end

  service do
    run [opt_libexec/"glassfish/bin/asadmin", "start-domain", "--verbose", "domain1"]
    keep_alive true
    working_dir opt_libexec/"glassfish"
    environment_variables GLASSFISH_HOME: opt_libexec/"glassfish"
  end

  test do
    ENV["GLASSFISH_HOME"] = opt_libexec/"glassfish"
    output = shell_output("#{bin}/asadmin list-domains")
    assert_match "domain1 not running", output
    assert_match "Command list-domains executed successfully.", output
  end
end
