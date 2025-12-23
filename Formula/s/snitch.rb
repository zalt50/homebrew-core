class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://github.com/karol-broda/snitch/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "5dce1da7674ffd46ad9aefdd638a52b06fd4f1862fb19d5d087dcd16a429bf76"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e246e974728965429127e0c3643de8eba12f6ea805ede435973f4ccca7c3fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aeb8145f36d69a6be6e92cbc399ff1d5ffcf26b807f54422224ab73b0107fcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a65217b5e9ede694b59593bf875e1cee96eb9cf8127b134673b9f0547754f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "143199be11d530c3abaac5b0433033bcdc1e76d6e703d16d5e9eb4325d6246fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633d992f34afa3d47f223209ef13b5c5930331ec9de641dd61e6dcdcf7dd0472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b338548750f5ea0cf7cfd9c99532f570b1c829b0ea2334e7aba53c9432c82b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karol-broda/snitch/cmd.Version=#{version}
      -X github.com/karol-broda/snitch/cmd.Date=#{time.iso8601}
      -X github.com/karol-broda/snitch/cmd.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end
