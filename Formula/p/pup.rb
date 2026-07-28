class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "c352b0059882810dacd8f0bc89b2a79d9e410e11029a1ce41ed3af93f0c6e122"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "498fc8597d17b44bcd3b8870c76b1c1bfacd444d6a20d506a08682fe186fc5c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a191e333f96fb383f50fa20028b65dd7331a745cfc893ed20eec98b8c5bffbae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ef88a814cb1bd31f819e90c21140b8c8ac786fad0ccd0d5a041cb50f02dc99"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a33609a0a754e6a9af221f21a3ef03a62627cecc15a0188a88d10135b7016c"
    sha256 cellar: :any,                 arm64_linux:   "731e98e97b75b85e3d3a8d874991db3ac08ce24b454aa2bf8b408fb0a66c8061"
    sha256 cellar: :any,                 x86_64_linux:  "73e1e5a9259039b6c714cefaa863da96a88b685eea3c4ec7e974e235b5cc71f2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
