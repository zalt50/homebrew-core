class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.54.0.tar.gz"
  sha256 "bc913b80bcd4da05c0d0d355345702f20a5b413dfe8e66399094a740dbf425aa"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b7ebeadc90cfb7b130ac38c4203ed06af971a7c45ad68a6ffddcde861e0e7e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7ebeadc90cfb7b130ac38c4203ed06af971a7c45ad68a6ffddcde861e0e7e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7ebeadc90cfb7b130ac38c4203ed06af971a7c45ad68a6ffddcde861e0e7e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d3688a1f353883926614ae749283c88ffe0f9520dc740f457602f6b180122d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "126a176651948de50dd825166ecad114e62c0caf2c44372d7fcc2d8ee029b9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af24ba304a3e412422248234aa9ca1b765d243ac7d7039a9599c8260ee6c7f32"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
