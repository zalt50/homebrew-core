class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  url "https://github.com/rust-av/Av1an/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "58eba4215ffaf07a58065e78fb4aec8df9ebda48e9d996621d559f3024b3538b"
  license "GPL-3.0-only"
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  # Differentiate v-prefixed tags from old version schemes
  livecheck do
    url :stable
    regex(/^v(\d+\.\d+\.\d+)$/i)
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    system bin/"av1an", "-i", test_fixtures("test.mp4"), "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end
