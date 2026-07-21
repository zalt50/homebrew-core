class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "c793367242acda48c78cb5ed81f2b0ed8bc7df47cc134f30603061003f58fd98"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca4a7f868c41a21002f3c3530c4820dad2026fd4aa03987c1a4aa3b7cf6e42b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4e55862e848a1f4127ea80ec584a6c8fe285b6fa9085ab90eb603c257666f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864376c17e51aba69fc275a2e3abb0935a98e80b32c4203a9348506e610bb07c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dc73bbf8fdab9d1c6308442c8ed708f27c009ba604249a3548fb5d8508e73fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2342aefd83dda4907568b0101ffe4c8a9f19ff2192c043e4891685205665992"
    sha256 cellar: :any,                 x86_64_linux:  "795bae3afad15872c6d8774d6b8d1ebb1a38bd12ce13b3e2bfd85454b016e20b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
