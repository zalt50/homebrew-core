class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "4ee65ebf3d2d2aaabcb1b684dce78e631692513963e6ce749c3a5bba57f76edf"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7aee03994dbfd423291743c311f1221fd487e3cac58fae4d0974773ecf598a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40dcf449eda9466eeeb23cad0a15152dc12313928b77a40491ac6798f11ba35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "698c6f46cf7bbdddcc8c6a1384792f31f3b82945e2b0abbd1a287357edecdbf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee6dc14f04241daf4a8b1ec0fb552b6a20f4489dd57b7843c5efb195068f5ff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c594a875618486488fce75fbcb9b2ef6f201240119dc512aaed8ea86d2d1dce9"
    sha256 cellar: :any,                 x86_64_linux:  "d6a8e387ba5ec4c96d45fadf694378bb1670a58fa952c13c175f9b83a40688d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pv-migrate"

    generate_completions_from_executable(bin/"pv-migrate", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pv-migrate --version")
    output = shell_output("#{bin}/pv-migrate migrate 2>&1", 1)
    assert_match "source", output.downcase
  end
end
