class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "7e60027b9cfebdd1e0b5714df102c41b89867abc9b19d235759ac6d9e1abebab"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39133b99ab9ae2bfb4c95fc1ccb51ad0981859bcdbd13afdc6ea5a353ef97545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5711d4ac5c419fffa58a74a737b5f5ee5255136e5c655545928ead09056ef79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e6332ccc4e1939e5c222db01e7f05c0483ba17b702ed1e80751c4d0a35c0c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14034a6393f3e3a7b7b835295c83622ccf79be38166393b5ea83eb92ec530ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8620d740d867100016e2f3bb2b9653bcb896ad0bb3a4e855a2ec191bd8a889"
    sha256 cellar: :any,                 x86_64_linux:  "ded01bcea2bb2eeb0e2a4c0b6c8653b917cb1dc9b4880067dd97f9b99fba907d"
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
