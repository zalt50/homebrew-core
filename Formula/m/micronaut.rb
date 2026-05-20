class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "15cf79688caafa1181b365ee484607b44058792313cce6a1939c24f493b41e04"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dd99360705ca1f56f5836c8afcc92abbccb8d79655df23c2b6a41db496f8a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce58194118b15142c015586ece8b55e7e797f1bfb0c68a83daefe335f94a16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32a4eec12c601c647a0b78506995ce72dc2ccb170ccaf20caf56c9791ef9c6bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6502a12f1d7f6e3c739ede6fc72d655bf8b271139968b6e058fa185554ce31c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c78d0652b1d2d82345e3cd30f96f9ddd8472d9869eea75c8e0fccc3f734f2fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41627c3c46175dafc0426da23f8ff3f154060d227042e7268b3386b88201cc1"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
