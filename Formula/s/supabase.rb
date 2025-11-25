class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.62.5.tar.gz"
  sha256 "fce4f7c06d511e5e62ecf70eef183a1c1f21620ad5faf5dca0607abcfb08eb81"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1884a0e0385738cc5222a00da74605a17e57aab891d3ad587d6a869e714b8349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e23f3d4b247a6ebc1cd0dfd1700edfc806716649f94d007cc08b00f571ece0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2fb90a9d2f9263cc3c018daa3a96f73e894105c07a893f0071b48f4fecee223"
    sha256 cellar: :any_skip_relocation, sonoma:        "34c96ef206a6e28f4d00a9eef8e8cff4b841db8f4fcd15f2b19d645a56553ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68985c7de040577ec33eaac2a0bfc47e4691650c45e17d1248f148fb13164ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d459a393863cdfbb01e096d092eb7b11b9a53100d61ac5f81a16afc11265d127"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/supabase/cli/internal/utils.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"supabase", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
