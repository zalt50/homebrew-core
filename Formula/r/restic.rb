class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "800779b6c4c2396971c0567b09ccdd435e03155e1a0ec94e8bbf3d98641a8bc2"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6fd5d1ca0cacb7629f7bc480c81dfa36c551bb610e5559e9a86a0712b4bc2a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fd5d1ca0cacb7629f7bc480c81dfa36c551bb610e5559e9a86a0712b4bc2a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6fd5d1ca0cacb7629f7bc480c81dfa36c551bb610e5559e9a86a0712b4bc2a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d6d0d3486f2a8c77bef02e15e860c3ee9ecb2a78c217dffda26c125d4f0b3ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf1e673d725c5d20dd4829062da1a18710f0ce9780eb8a0f41613d913bd0397e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f787724e226c9f3ee6a6e1a94feb01262102ce1053d1a09ed18f5f8d835a6f96"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go"

    mkdir "completions"
    system "./restic", "generate", "--bash-completion", "completions/restic"
    system "./restic", "generate", "--zsh-completion", "completions/_restic"
    system "./restic", "generate", "--fish-completion", "completions/restic.fish"

    mkdir "man"
    system "./restic", "generate", "--man", "man"

    bin.install "restic"
    bash_completion.install "completions/restic"
    zsh_completion.install "completions/_restic"
    fish_completion.install "completions/restic.fish"
    man1.install Dir["man/*.1"]
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system bin/"restic", "init"
    system bin/"restic", "backup", "testfile"

    system bin/"restic", "restore", "latest", "-t", testpath/"restore"
    assert compare_file "testfile", testpath/"restore/testfile"
  end
end
