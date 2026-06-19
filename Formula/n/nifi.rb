class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.10.0/nifi-2.10.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.10.0/nifi-2.10.0-bin.zip"
  sha256 "46709e6550e4235fe821c537e26538e31bb0e038153519a69ba33d3e9e2f8641"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f30a61dab8b730a8f0f17684a8bb1de47fd6b89b5624f72983ea4c067e362ac"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
