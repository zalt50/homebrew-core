class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.1.2.tar.gz"
  sha256 "8470b63320b0c8823b5866710a2bb8c222bcf79dcd97b887ba881e76f34fa0d2"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a53525f1d3594a7e6a2b8e77d0291649d60a971addcddb93df425be107a55a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a53525f1d3594a7e6a2b8e77d0291649d60a971addcddb93df425be107a55a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a53525f1d3594a7e6a2b8e77d0291649d60a971addcddb93df425be107a55a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9655057791daaa95bad71d39e1754a5f8a1d9f19bfe7e079e89a89405b62f8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e10108478ef7296f529a07c6de7e090a82d0841e56663a2bf4b380f9dcab32"
    sha256 cellar: :any,                 x86_64_linux:  "745e2e9219c2ced2e667f3ca654c4fbed5733b654c094972e9fa48cb517f9394"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
