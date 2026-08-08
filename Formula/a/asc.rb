class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.6.0.tar.gz"
  sha256 "51342dd56d3d8d5ba75abf012d44e0cd9d9c32322d7d7ca0914ca21ad36b0e39"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85c4675ae91231922bc1021092d6fa9a5038bfd5f4ff262de4eadb32c6d06130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dcf44e4c581bd3dc32af07294a37de709985bc3addee2b5365b0bec3a966a81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3eb25a362a4a84a97fdfd0122037489d5ced02efe3ef75e229e1a9aaa90dda5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef7e1dcea9693ebdd11f7ae0690b4e79bd1d54fb4459f367bc4f1c24b76422f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c9db0214ae11f34be2678a2468b4ec2019b7468a5b65cba77062d499c02dce"
    sha256 cellar: :any,                 x86_64_linux:  "b1b1ba136b32644338875162dd418132280dcede3e5b6378a793a6b8e4d18c23"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
