class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/refs/tags/1.2.4.tar.gz"
  sha256 "be255a26452400a6ff79039e1c76592694bc602e7b1e0c40a64b841ba0e434ed"
  license "MIT"
  head "https://github.com/nanomsg/nanomsg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "93c1ee4687a5f170b4bbf47be2ce23c752ab3c37c5709b79c09a02e8b211b9ca"
    sha256 cellar: :any, arm64_sequoia: "7b9dca502014364a157d1317aad2cd9a78274687a0c048e02252d2c573dcb1a1"
    sha256 cellar: :any, arm64_sonoma:  "07a9dbcb11e6a688b40e5fbbc7206572b7dc60c66eb7fbda3918c4dd679ba97d"
    sha256 cellar: :any, sonoma:        "e9e3eefb66c9b9e8cc1ea2a31e7ebc1065c44d289e84e370956a6d76deb9eb74"
    sha256 cellar: :any, arm64_linux:   "76805bc190d05b44396e1bdd98b582a971f59a4d64f522bf7ebd5d8ae5497834"
    sha256 cellar: :any, x86_64_linux:  "58a74d2c4ce140514a6fe32b76cbb7737e1cb03c78fd7dab421b058ae61b0e79"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"
    spawn bin/"nanocat", "--rep", "--bind", bind, "--format", "ascii", "--data", "home"
    sleep 2
    output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
    assert_match "home", output
  end
end
