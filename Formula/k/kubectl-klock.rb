class KubectlKlock < Formula
  desc "Kubectl plugin to render watch output in a more readable fashion"
  homepage "https://github.com/applejag/kubectl-klock"
  url "https://github.com/applejag/kubectl-klock/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "3356d126bed9d9c0f39e9c788bd203dd3ab7c2c3734934814cdd4750a16ef36e"
  license all_of: ["GPL-3.0-or-later", "CC0-1.0"]

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"kubectl-klock", shell_parameter_format: :cobra)
    bin.install "bin/kubectl_complete-klock"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-klock --version")

    output = ""
    PTY.spawn "#{bin}/kubectl-klock pods" do |r, _w, pid|
      sleep 1
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "connect: connection refused", output
  end
end
