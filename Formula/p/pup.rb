class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "55f89b8b537feccb8f1e0e82464e7d216debd47ed1f161823050683ab803830f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0afc73ba423bc3e8bd8df8902104099c4c59defe01181e295285b67905d23df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3556a25b0639bef44c13e82fec83b6876129f94f12382b9cec9a562652b678"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7bc9696d0c3cab522733dc6dcd9173d91ccb050be0f7e2c8e79d62b9aa5bd15"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d4b3babb27720f083700f7a8902890eac1cb9c02145441a5008f21cff3c09de"
    sha256 cellar: :any,                 arm64_linux:   "70c28a888b0ae6bbb660fab5e561baee37a1e103b1703edc2c47f59e0af73dbe"
    sha256 cellar: :any,                 x86_64_linux:  "8191a6a30b9b41bda6c87027c1bd08c134421f8071c1cd45799ea386c9d24592"
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
