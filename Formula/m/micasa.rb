class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.58.1.tar.gz"
  sha256 "373f6d4ac2f6daf5ecffb1bc3f2d7d899b4e1bf1f6c01d8a2aeb636fafd69bd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec62721397f6315247876e97b0a9359e70629aec570e760db1883c81b8f8a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec62721397f6315247876e97b0a9359e70629aec570e760db1883c81b8f8a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec62721397f6315247876e97b0a9359e70629aec570e760db1883c81b8f8a9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "318ceedd90089e9ffdc519f7f04de58b12eeba7fc9b8dc3ae9d4add363115997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f134155a7f2d8e042fd61f5faf2e011b0e1ea1cfdad2e51cd71bacea9b8a248d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661eee999a7182745b72e1df7e7e2dd8db65bfd912e6bd631ac59f5e60fb0bff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
