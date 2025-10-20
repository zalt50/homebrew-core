class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.53/nmstate-2.2.53.tar.gz"
  sha256 "62d49d1684474931f12df86d447670b16f631a5c07c00f99c494b18f20e1d36a"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85b8f69e7477c2581b290727bf44da5a4f01f62e1fc991c0e1a04d04010a7045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd84c1ead0f232d13d6773cd5656e80d5094bf1a37be2000064f71143dc2a7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c0ff525fde51787d725db1df560ef0220982eaf4b142e18ae2e1b359c819424"
    sha256 cellar: :any_skip_relocation, sonoma:        "56baa081e788ad823f5bed68c7eedc107b6c9b26dbe6feda03a839050e7a3bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d32bbfbb19446cfb57dc475b594a31d239968cd36d05324cde4998957ca6df3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a6a6e457e5884f972f4a0c1b7791d4c3a9fcc824d3902712c36efc6b210332"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
