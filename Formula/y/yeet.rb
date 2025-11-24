class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "c27f50d0b35180feea156f8c36e8ccd40959ef83aa303049a3f19fdd86914f7b"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20fc2b2854628aee38648bb20671427ec86ef9872d58d6d1df92934766428c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20fc2b2854628aee38648bb20671427ec86ef9872d58d6d1df92934766428c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20fc2b2854628aee38648bb20671427ec86ef9872d58d6d1df92934766428c78"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ade8c9f0e28dde1e21e088970e8be2500ad75e52d54e77a6ed5b52acddaa85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b3c64e4df27cda60d14bf4b2bf9a60551e8d904ffce500d6957880b82621c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd3a1031582e973ad2b2ab73758dee95ebd1f1d01c076e72a620244d5d48979c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
