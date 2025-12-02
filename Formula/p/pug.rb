class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "e65a6b9b83625a6e1613125287775a92bee50121974362dae618e01da44f2868"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aec8a282fff48c161c20fdb85112281821a78be34bc5e5b4b3e65f4835739ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aec8a282fff48c161c20fdb85112281821a78be34bc5e5b4b3e65f4835739ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aec8a282fff48c161c20fdb85112281821a78be34bc5e5b4b3e65f4835739ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fffeda9bdedf61acb9648746d8234c0cc62d0194f39a9854558a883a84bccf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d370e68c688222514317ef7f31bb306a3bbeea006c12f73d09a466a1b136eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad1d67a56b0596316c25506def63cb419a1d889bc6d69c4bef7bcf8a3031c132"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pug --version")

    # Fails in Linux CI with `open /dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"pug", "--debug", [:out, :err] => output_log.to_s

      sleep 1

      assert_match "loaded 0 modules", output_log.read
      assert_path_exists testpath/"messages.log"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
