class Nessie < Formula
  desc "Transactional Catalog for Data Lakes with Git-like semantics"
  homepage "https://projectnessie.org"
  url "https://github.com/projectnessie/nessie/archive/refs/tags/nessie-0.107.9.tar.gz"
  sha256 "f93007d2b94e61b6b77bcfa6813401b990aafc909a5d235574ca679304b96ef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4632688c857751d544eba39a98e1fdc743d9763026360d82912965c193e3c80b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564d6d999782547d1301885709239bdfe3be0c1dd8dbc1eba1343d55cf7abc54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08cd0761405758b3c90106971c0fa76b7f5d099206c3fc41cbb7985428f6a158"
    sha256 cellar: :any_skip_relocation, sonoma:        "32fd909e6aa93530a354ea0ae60fd8affeb1418ddf2d5431c8836ea8297ecadf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b2595689d2eb169e892011b80171eb8e86a24da700ab34b555f47d645b7b3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59c019eca3580fe778029e4b2dd036a7a8ac48ba8005bcfcbfd6e60dac272cc"
  end

  depends_on "gradle" => :build
  # The build fails with more recent JDKs
  # See: https://github.com/projectnessie/nessie/issues/11145
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", ":nessie-quarkus:assemble"
    libexec.install Dir["servers/quarkus-server/build/quarkus-app/*"]
    bin.write_jar_script libexec/"quarkus-run.jar", "nessie"
  end

  service do
    run [opt_bin/"nessie"]
    keep_alive true
    error_log_path var/"log/nessie.log"
    log_path var/"log/nessie.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    spawn bin/"nessie"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end
