class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "8cd18c13a85d5c05c912cae5b3641a606ce2ca0bf70ef5c2ed26dcadcefd7f31"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eec40a4cde267ded267ed4491aab35525bc368f41626e1aed61029d95058406c"
    sha256 cellar: :any,                 arm64_sequoia: "58e43eee8eac775c6f0e45ac2c81e3a5d0e012196ac15e21a05841139ec0e296"
    sha256 cellar: :any,                 arm64_sonoma:  "947eb675e175206e59ab82fae047bca196edac2b5620388cecd5a9ade48534ab"
    sha256 cellar: :any,                 sonoma:        "6c2948301889be32e1d73784de3890bf110046d4c1d3b4f632153ff1f5ea5566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e453f659d0f07be2548da693b142d7696b827577238fc335e159de5c77e464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ef1f7d0208a1640e08c9bba3beb30dfe5f580025919bc7e54adc50585f18f1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20
    sleep 50 if OS.mac? && Hardware::CPU.intel?

    output = testpath/"test-converted.png"
    url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

    system "curl", "-s", "-o", output, url
    assert_path_exists output

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
