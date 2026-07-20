class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "32df44adf16990f7773a9f498e4bdfae16e414e8a8a6189c10d508dfa0f00026"
  license "Apache-2.0"

  depends_on "go" => :build

  # Linux GUI libraries are only needed to compile the vendored GLFW in
  # raylib-go; the binary loads them at runtime via dlopen when `--gui` is used
  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcursor" => :build
    depends_on "libxi" => :build
    depends_on "libxinerama" => :build
    depends_on "libxkbcommon" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "wayland" => :build
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/jdefrancesco/dskDitto/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dskDitto"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dskditto --version")

    (testpath/"a.txt").write "This is a test"
    (testpath/"b.txt").write "This is another test"
    cp testpath/"a.txt", testpath/"c.txt"
    output = shell_output("#{bin}/dskditto --remove 1 #{testpath}")
    assert_match "Removed 1 duplicate", output
    assert_equal 1, [testpath/"a.txt", testpath/"c.txt"].count(&:exist?)
    assert_path_exists testpath/"b.txt"
  end
end
