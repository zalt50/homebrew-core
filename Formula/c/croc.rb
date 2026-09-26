class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.5.4.tar.gz"
  sha256 "16910b594704b40e9df35eb3bc637db675fe3d770a4588bd32b5a12c5ff174ff"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a62776d24a0adb0d64506318a39acd76b3da90b3e44a40dd07ccb31bfd0599f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f370061aa23441a406410cb927e06da1eba2211b0ef72b75eb3d4c4143ca96e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06eccc15708adcec3b97bc5d05e47f7f30d8ce658183fb59dd3ddbab98cd9cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab133801c01d259136766f0c02605e3f62e32f26d01183718f0defef6f97cb6e"
    sha256 cellar: :any,                 x86_64_linux:      "39a1e76971d82e26463e2cd06d391769a0ac7edc38addd6516f0f3efb40917cf"
  end

  depends_on "go" => :build

  # `test do` block runs a local relay
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
