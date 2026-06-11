class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.1.0.tar.gz"
  sha256 "f5c8debb20a68d136018b1bc7c0a5250fd647440134ed50dd1fc31ec30f43d4b"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcfc09bff02929c8813f1d545e41e4738575bdfc1a48a99424cf8c6ef6fa0db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bfecbd2f17d2de2c3f4e43bf973d4582b30294c31b4d3eff2669b5103fd2fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754fb9a84373ce3fea7a87638498260b604aedc1d1b549dbcab0718881b2d8f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f7b0c66b3930630d4d7543f22c59fd0ae77945f3a404874aca550d9176ef71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c6e2f435b64a6227ab7ec3221a804537e68aecc3f00423297554f399a39cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f50e7b18012cf9f724e5c337ead3ee11318969c02aed65de3ceb4b8bf8a960bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/cli")
    generate_completions_from_executable(bin/"mcap", "completion")
  end

  test do
    resource "homebrew-testdata-OneMessage" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
      sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
    end

    resource "homebrew-testdata-OneAttachment" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
      sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
    end

    resource "homebrew-testdata-OneMetadata" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
      sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
    end

    assert_match(%r{^mcap #{version} \([^)]+\) mcap-rust/}, shell_output("#{bin}/mcap --version").strip)

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}/mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}/mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end
