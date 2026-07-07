class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.4.8.tar.gz"
  sha256 "60f8a15a6fde7bea34730374b66bf8b3162770cf047fbf52cdd574f4807c6a7b"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b84d855bd06830eeb8b9c8d44053c68200c43e44d2181e38fdc6a19ccf8a8f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b84d855bd06830eeb8b9c8d44053c68200c43e44d2181e38fdc6a19ccf8a8f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b84d855bd06830eeb8b9c8d44053c68200c43e44d2181e38fdc6a19ccf8a8f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a34807b99b0f1990cbc9696f14af675c20f7b953574c11c946b5ef6201dcd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd32f16421724056d74363b9efa3c1f7e7945d451e848c0c8e826c62924341d"
    sha256 cellar: :any,                 x86_64_linux:  "5ee18edb1fa0ef5e270beef2f6f04adf000628db60233a44add21e6bb3cc6fbd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    ports = [free_port, free_port]

    require "pty"
    pid = PTY.spawn(bin/"croc", "relay", "--ports", ports.join(",")).last
    sleep 3

    pid_send = PTY.spawn(bin/"croc", "--relay=localhost:#{ports.first}", "send",
                                     "--no-local", "--text=mytext", "--transfers=1").last
    sleep 3

    output = shell_output("#{bin}/croc --relay localhost:#{ports.first} --overwrite --yes")
    assert_match "mytext", output
  ensure
    Process.kill("TERM", pid_send)
    Process.kill("TERM", pid)
    Process.wait(pid_send)
    Process.wait(pid)
  end
end
