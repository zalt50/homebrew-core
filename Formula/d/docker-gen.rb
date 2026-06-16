class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.6.tar.gz"
  sha256 "db645ad89e20d93f8c3a1d68b0e8a6a50b4391005975acd8e82103735a9fee96"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f870c74029b93515bfdd47671aead3f8490240953c4b6ddc90578ee1478b2f5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f870c74029b93515bfdd47671aead3f8490240953c4b6ddc90578ee1478b2f5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f870c74029b93515bfdd47671aead3f8490240953c4b6ddc90578ee1478b2f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2883706dc5918e6bca8f7aad28e75536af00d95a5bf23955ae85b3cc39e558d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb958bad524f5da6d0a8a26ea2078e0723f68b8ed950659e4c140f90a4a42fa9"
    sha256 cellar: :any,                 x86_64_linux:  "acdfcbd65bacf960b24902747afa538749d1d8348980d7be48f050429d40be26"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
