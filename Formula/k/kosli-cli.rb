class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "290a015b637215343d032d42aad1c6e3d23fa3b53bff2a17a98cbfd4690a3614"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f891b76a109b4cb5fb176d0c0f764c4e8b27f314da6a55c3da1c8c22d376ff3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31143015d45a21a768e4ebd9b5714d07fc6f956ae53ed4f2dfc59582b2cb6b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7880e32cf9fc67f60e2556d1479834607e96fbc14d294d61cb2921acfe63a9e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76c455cbc71b558a32dc1fda9f664c47798e25f6c5e119914c6eafcdc2941ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f39be04d80bc4992bb7efc25d5faf5b1a2c6428d8b67c6ee09d134cd3d4ca6"
    sha256 cellar: :any,                 x86_64_linux:  "a4daabf35d28670f918a393b2729959033476aa7f29de3b6de636a6108207f54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
