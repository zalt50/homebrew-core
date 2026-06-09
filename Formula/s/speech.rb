class Speech < Formula
  desc "On-device speech toolkit for Apple Silicon: ASR, TTS, VAD, diarization"
  homepage "https://github.com/soniqo/speech-swift"
  url "https://github.com/soniqo/speech-swift/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "c896549bdd4c02b17cc9f821f27eb67f2316d116fa056343d0f7c4d810fe32bd"
  license "Apache-2.0"
  head "https://github.com/soniqo/speech-swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1eaf234bf392704ca19b6ec63d5a3eedc6092b3b32c1e1a66c6481e11a4b508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a97e93af8b177daabb495cd99b63ab03a20f58c55596f588e0684ba2989a446a"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    system "./scripts/build_mlx_metallib.sh", "release"

    %w[speech speech-server].each do |name|
      libexec.install ".build/release/#{name}"
      bin.write_exec_script libexec/name
    end
    libexec.install ".build/release/mlx.metallib"
    libexec.install ".build/release/Qwen3Speech_KokoroTTS.bundle"
  end

  test do
    # Error path: nonexistent input triggers the audio-loading code path and
    # the binary exits non-zero with a CoreAudio error message.
    output = shell_output("#{bin}/speech transcribe /nonexistent.wav 2>&1", 1)
    assert_match "Error", output

    # Server-startup: `speech-server` binds on a port without preloading any
    # model and serves /health.
    port = free_port
    pid = spawn bin/"speech-server", "--host", "127.0.0.1", "--port", port.to_s

    sleep 15
    health = shell_output("curl -sf --max-time 5 http://127.0.0.1:#{port}/health")
    assert_match "ok", health
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
