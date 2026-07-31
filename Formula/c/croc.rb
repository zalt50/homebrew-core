class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "6a147e765f5e47d7022cd43f72fcc42e59333a2be0ff09f98bac1d12215f4af0"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f2323a17e2a4be2189842b5ddef1bf4e35fc9f57df2b410f0d77aa0cfc6d0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f2323a17e2a4be2189842b5ddef1bf4e35fc9f57df2b410f0d77aa0cfc6d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f2323a17e2a4be2189842b5ddef1bf4e35fc9f57df2b410f0d77aa0cfc6d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "50ff00469f386b6155b284812dc4832a6961627cd273e6abd289606bee04e8b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb7eb35ab6d028717a850d84c046cd8b31fb5dcb1abcf82dbf48293f245b97f4"
    sha256 cellar: :any,                 x86_64_linux:  "69089ae743cf9770e2c671f789d334d57cb0ae0275b02291c6c0cff298e645b0"
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
