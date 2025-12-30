class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4b498e776679da822a67e854857cecdddf5d012c9cfc03a3f60c3b0a6ca0ff4e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1de251348620d1e1a4e9e877d605c1a5813603b6a809651e8a9554d2e2643975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bab519e6552ced20a13260c72f72546b8d45eb36956b0e99d7fcea3f512d915b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338efd70193bd6f0c891820313840f81d522fcc5110a654e1e35339c4a5a8856"
    sha256 cellar: :any_skip_relocation, sonoma:        "c373505e884ea846fa3af2b77bf936a467e82e253632ecf0e0f927b1668ab55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30de8f767c4aca0b5708bf0c7ef2e48f24a0176a539f752f8cc717d1fd2b4fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf2f9af69ab6c4a0bfb7364310acad673d80a2e556166b97ee0ca3165ae246b"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
