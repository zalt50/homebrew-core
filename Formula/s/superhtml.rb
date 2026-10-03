class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "92b2b76e6a38ac0aa2e10fe13ce4131366c2f1bb3d13131687aa8a2df82de82a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c453ef5eeebdb2eef2a2d6669543858f48830db8db9bb41059dd6451b4f14053"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ecdeda20aba3c932e654ce1a7ad91174f5084cc83633c5d9cd6f1390daee912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8012a4daf05ee0ddbb51d09172fadeb4fe23b21cadeed03a42c1663964bd52dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bae9719b4bb4567edaf1678911be594bfdc8d537996bb723f300c3fb0f2aad93"
    sha256 cellar: :any_skip_relocation, sonoma:            "f41742a7a7b61ce1e6bf019e897ae0b3f0076215353a8af4b7f53750533593f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b468973d40b401cf79782c7b85cf42696046c5064797af71a24de169e5b33d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8874ee426039b691bb1faffd504ba20c22be4501f249d0bf8f84f2f46c636f5f"
  end

  depends_on "zig" => :build

  # Backport fix for fmt
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/269502486163f22e03f3ab5aa818ed729f8034b5.patch?full_index=1"
    sha256 "9f01c36a089883c5c450f50562857ea869bb3dbfe940012d84b91acf3fcfbeea"
    type :backport
    resolves "https://github.com/kristoff-it/superhtml/issues/151"
  end

  # Backports for Zig 0.17 final release
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/3e37d8b00b211ac1591766cfb0ea3efd2845bff2.patch?full_index=1"
    sha256 "ed022f8c14de6803b30a576146d82dea6a10bd6ad6fa838e56f54f2ecf682d7c"
    type :backport
  end
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/abd86c4ba995a37b0f0559801b32b35cde8bcef9.patch?full_index=1"
    sha256 "fc7d5049191210804ac87130decf75006b738de403e9b1918e029f7949f4f3f5"
    type :backport
  end
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/f0deee80ae422938d5cdc43a5598c417670db38b.patch?full_index=1"
    sha256 "6b4e48705e52807e3c0286c938721749461c7947ca64dae09bc8de22a4b0ee8c"
    type :backport
  end

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    # upstream issue: https://github.com/kristoff-it/superhtml/issues/108
    inreplace "build.zig", '"unknown"', "\"#{version}\"" # patch fallback version

    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superhtml version 2>&1")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    HTML
    system bin/"superhtml", "fmt", "test.html"
  end
end
