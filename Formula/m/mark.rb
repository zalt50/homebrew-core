class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.7.0.tar.gz"
  sha256 "a572184aa7f1d8648a3e1d4323df1fe99f84c498f5fbe7ae08a31113b9298fc6"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2abede35b9e1ba8d1db4f988a28e1c82a43f728d8c3452234b0731bdc8494b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2abede35b9e1ba8d1db4f988a28e1c82a43f728d8c3452234b0731bdc8494b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2abede35b9e1ba8d1db4f988a28e1c82a43f728d8c3452234b0731bdc8494b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "97de66449a85cd35d712d144d21bf8a54ac7c77a4c26c1b005920e226474035d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf11f86d608eda6d8becdddc79af24f20531f1bfa11a7f17532dde7ce989a74"
    sha256 cellar: :any,                 x86_64_linux:  "beb47b730c99ae3d71e1aa1bb85a9fb780ffb55bd14c997a3efbc8d452770f2e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
