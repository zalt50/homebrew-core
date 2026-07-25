class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.56.tar.gz"
  sha256 "7f2bae171fbaec2e3735f893bec157a4e8c7a28ce9f89487f55f6ec89e78732e"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "153769ab2f9251bb9e5857e345d82a18727c86d2d1094a4e347b213b72faa640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541d1c8664a252572de710168975af5c5222d9a135066626065550dd50940b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec2f8d96907248f9cddb97ffe79fb46feec684bbf2afe18ae35a792e0adc56b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "270abe48826d8d0e720d46f60a4fc3730c5c9c2bc5d4c4a132bd98438b5121ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07906c4f871657eae408b66680b4c4db79f6d2e2a824c66ed41474a031145bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2fcfb7c515dae617324581b61b223f511a778a1f3c08f107a66ad2a78c3eb2"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
