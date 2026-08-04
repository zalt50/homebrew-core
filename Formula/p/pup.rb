class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "6362b4bceb295b5caac6760c4ca06331be8d2af018cb3126f4a3ccafc8aff982"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc55cc989351f5bd40ebaa900123a334919c3c8f3008b309d6a060c784b6747"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2562c20349f2702a0a5bb76fac3fb6fe4efa6ba4870d80145a3f289ae50948c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0572dff0b07950371a9fbb1592e011bf5286a966857a80a6f06f4cc7effcd78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "30a18a6e343768f72e529bb8d6f7b4a2fdb334ef960b9f71d721e48e0285b259"
    sha256 cellar: :any,                 arm64_linux:   "9b6f75d3e1ff401524729cb07d9b521819866f200717ec1c9e7c8d2335207c7a"
    sha256 cellar: :any,                 x86_64_linux:  "d99c92dacc6b968217a7a73288f47d25fd8906377e39045be17599212f96c4ec"
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
