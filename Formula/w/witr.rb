class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "5d697999be5684a2723d92e649a72c80ca2df464f6e7dcf5e52551b5ee9194fd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fb5ca20e7e77bef72853ff1c93d6d83743a715f642f27aa5812bf63530278fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "527739c6cd44d1141380820ea184fa58a00125e7f515cd073a1698ad2ffcb565"
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
