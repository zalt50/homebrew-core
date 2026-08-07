class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/d2lang/d2/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e2fb1fe1d7b76196ee01a3a244356e7f22f7d3c30922f8d6a8a193ac05737172"
  license "MPL-2.0"
  head "https://github.com/d2lang/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd0f0a83c8e007573dfe1a6e788fcac0b8c8dea81e9f5f77830cfc564f9fd024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd0f0a83c8e007573dfe1a6e788fcac0b8c8dea81e9f5f77830cfc564f9fd024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd0f0a83c8e007573dfe1a6e788fcac0b8c8dea81e9f5f77830cfc564f9fd024"
    sha256 cellar: :any_skip_relocation, sonoma:        "87365ba257d80c5c45ca447a6c2e4f99a52de40fa86cb3b3de7c4a22306d590e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "387869048198a50f1ce08f58cf6ebf1e3a7e024643eb07aad9eb27f2bb674cda"
    sha256 cellar: :any,                 x86_64_linux:  "fe0912f4930296c489ba59f3b0be08571f2a86ce488d63f8d340eb19757d3acc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_path_exists testpath/"test.svg"

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
