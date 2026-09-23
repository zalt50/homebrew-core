class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/2.0.0.tar.gz"
  sha256 "b0601a411fe041baae4da86bab4242fc964df6229ff2335955f1d5df46f2deff"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "43bc34990dd2c6f0d7f83c038fa84e1b4edf37b62d537f3a4a6a3c2d6f3be674"
    sha256 cellar: :any, arm64_tahoe:       "66169557403a27f0ba6f4e2ad043108b69dbbd813ae9b523e5bdd70bd4198ed8"
    sha256 cellar: :any, arm64_sequoia:     "8b4ba92f1a565e98368cda5f60b3c47b778197bbe497913bdd7e90b342cb321a"
    sha256 cellar: :any, arm64_sonoma:      "c47ae0184f72f2a2a3fc2a99b2ab0a3c3a0759608e6909d190deebdd32b5737e"
    sha256 cellar: :any, sonoma:            "b62e91623bd651cf0f6a3fe9cc3bd923ade96c471fb7d4de00407ed273ca3446"
    sha256 cellar: :any, arm64_linux:       "0a8d16c9c10d85bbd9d1eb169236c3e2b59966f23e02da9fd1cf1dd09676ac8f"
    sha256 cellar: :any, x86_64_linux:      "f7dfe751e1b76008a6af1545cf2ad181bc48c72f26de4242e687e2af90634f32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "opus"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # `audiopus_sys` links opus statically on macOS by default
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "opus").chomp

    system "cargo", "install", *std_cargo_args(path: "cli")

    # TODO: drop backward compatibility symlink for the pre-2.0 `faircamp` CLI name
    bin.install_symlink "faircamp-cli" => "faircamp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faircamp --version")

    site_dir = testpath/"site"
    release_dir = site_dir/"release"
    release_dir.mkpath
    cp test_fixtures("test.wav"), release_dir/"track.wav"
    cp test_fixtures("test.jpg"), release_dir/"cover.jpg"

    build_dir = testpath/"build"
    system bin/"faircamp-cli", "build", "--site-dir", site_dir, "--build-dir", build_dir
    assert_path_exists build_dir/"index.html"
    assert_path_exists build_dir/"favicon.svg"
  end
end
