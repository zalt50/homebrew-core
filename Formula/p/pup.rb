class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.12.0/pup_1.12.0_source.tar.gz"
  sha256 "723d2b372096295d3e515d3f17c09972c2aa451784a7355704a6db42d34955d2"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60a51f55b9d9bc220e423092abda5b080e60dff36ace3cbfce8808f21e348135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a42c8d42becd70ea08b7a46f7793c2d2aa1585af53410d8f25d6bd03f0f65c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9bcc3638108c0fc4cb51b707e788be52f1f3fc9220d424739ddfc1d65462342"
    sha256 cellar: :any_skip_relocation, sonoma:        "b95739bc02c2639f3fb9ddb7797560289fe56b8b66ce6e7211431c9e9de2dee9"
    sha256 cellar: :any,                 arm64_linux:   "e6148cfc72304eab9ae764e161ef5b37b0a582fd810e78a74400b01f18bcfb0e"
    sha256 cellar: :any,                 x86_64_linux:  "52d2fd6b92fa81c6ddb64387749d50e5627306bad68a83d048ff86fb4878962d"
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
