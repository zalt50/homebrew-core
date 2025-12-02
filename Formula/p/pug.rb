class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "a65d9d6e381b8e3efd22e90b0088f25c048734072ec6f132a39f1b7c20e9ea3f"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3b73b784bd3dd810fa886cddb0f594fb6f4b43efee2ec76b6748ead630ac01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3b73b784bd3dd810fa886cddb0f594fb6f4b43efee2ec76b6748ead630ac01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3b73b784bd3dd810fa886cddb0f594fb6f4b43efee2ec76b6748ead630ac01"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3210925ccfca2efaff01e3124aae5a97bbf512ea099832675101332d59663f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec99af216ab909cd29281034616eba0d9681d48301103827149cab3f736d0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2a112863f1bf13e77e70f70979de780d649057e5a2f5de785ccba55143eb56"
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
