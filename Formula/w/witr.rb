class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "5d697999be5684a2723d92e649a72c80ca2df464f6e7dcf5e52551b5ee9194fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d7241f8fd0b182e8c3be4c8e04a729eef7e542b37361c0a0f9735ac480d0c71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "efd5dabb1e235a9d62b75455d4fd65615d3c3dca73f446285f42609441fa754d"
  end

  depends_on "go" => :build
  # macOS support PR ref: https://github.com/pranshuparmar/witr/pull/9
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end
