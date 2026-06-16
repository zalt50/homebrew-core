class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.60.1.tar.gz"
  sha256 "96a9ef64b6501822b42a4ef136c2af61e35dd374ace3aff23087048a91f8a11c"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a49fea92f5790647871edd393a7d375d044809587cc803ee49f316787c7d89b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a49fea92f5790647871edd393a7d375d044809587cc803ee49f316787c7d89b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a49fea92f5790647871edd393a7d375d044809587cc803ee49f316787c7d89b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "87b5c43d5612fb668eee4db2ec139d71c721b56cb95d0791cfa4d406a2c972f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10deee2f6625f4b67b5cea78cab96fa9c0a6165e469eb49daa4f5efb6766ca3d"
    sha256 cellar: :any,                 x86_64_linux:  "e8ecf385305f3f5eeaab31ce8b1cc97dfe0668376abaebfe8b3dc60bac5d31d7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
