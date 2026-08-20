class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.github.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3c9758dd49f635af85530a7763248e2f4532757fec0680ae6047d44fa518a45c"
  license "MIT"
  head "https://github.com/ahoy-cli/ahoy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f18d6fdb5b7f570cfb8c9c8c19924baba15285fda5dec40931e8ac2011cc53d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f18d6fdb5b7f570cfb8c9c8c19924baba15285fda5dec40931e8ac2011cc53d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f18d6fdb5b7f570cfb8c9c8c19924baba15285fda5dec40931e8ac2011cc53d"
    sha256 cellar: :any_skip_relocation, sonoma:        "930a7e72b2b4c6eee7c93c0fa2d4bbeec939396757f6636fb93f5539787d9aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d59f8d324b5ba60b8f4d73739ade8683c8ea6cec38ba5da25fe45e980c6de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f4378f0ba779768803fb338c0c7d2111f3ecca535c19f1ba67bea20db17f6d4"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}-homebrew")
  end

  test do
    (testpath/".ahoy.yml").write <<~YAML
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    YAML
    assert_equal "Hello Homebrew!\n", shell_output("#{bin}/ahoy hello")

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
