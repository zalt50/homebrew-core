class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "32df44adf16990f7773a9f498e4bdfae16e414e8a8a6189c10d508dfa0f00026"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45cf9faa4cd03e7ff1bd747b6171a180b8fc2d21936a449493ba972c86a8e9d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d8137ce7c81e90db6224e318d7e18ca89997284b4d51eb658d4751339b19277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d827d62e545bd6a5cb9af38e094cdd95c2bb93bfa5fcc9511e76d8be78f8d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2448b0b15e82c679e040c294804edc0bb51bf1f9a16f4606b1e6b34fa95837c5"
    sha256 cellar: :any,                 arm64_linux:   "24ecfecf06677d65f7ad76ea117ad59e0a357487b43682c71475d7debd169116"
    sha256 cellar: :any,                 x86_64_linux:  "f1d8dc061e09ca8a11cb1e4036b0d635a139315eed6c1ecea7ea3e972da98583"
  end

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
