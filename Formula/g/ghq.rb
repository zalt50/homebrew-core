class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.11.2",
      revision: "b9273dd116d09b423073b83e7c0d82ef508d985a"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd65b16e1555324acc368ea94b7235a38236403fefbaa3f3aa011a8338a8974a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4a25725860e85ec885b712f3927b27be56ad4ce57b49f4eee5049340752f8bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97a643d1c039e55b539aef2bfdbe5f0425950f55171b0b8dc21b8ed5b93f7382"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac628349868568ae88c402970972fc1f2a9d987d539e9f8f9283775bffa039f2"
    sha256 cellar: :any,                 x86_64_linux:      "3a663e5d1fab43ef30b05939dab140e5dc21d59a1baeb05a189fc16a94fbb0cc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "all"
  end

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
