class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.106.tar.gz"
  sha256 "430442f6416421ab6a0937e3e1406d627890e4a009b8cdf81bce0e2978d47ae8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6154e7eef23337102638e516db0250174fc23ceb48e0a596d2442741b8ad1dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6565f95be3418b90214880f068dac9b3c4a9fc8189b194337b54a15b666ec7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f130a21c25c880e0b1324896e7f49c818a51c439fb5aca592686dfd4a65e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d01b0d69545f53131e8e158f89352bc88f5003425b7fee559143635051a80209"
    sha256 cellar: :any,                 arm64_linux:   "deef4e85f72ec79f708a92557eb0393badfbc6ae6c27ea4dbe7378459d7c8933"
    sha256 cellar: :any,                 x86_64_linux:  "a65a6b4be4b053d6ed670ed851f31b7a3018ae1eaecf1d6d393068f7687f1adf"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishTrimmed=false
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/officecli/officecli.csproj", *args
    bin.install_symlink libexec/"officecli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/officecli --version")
    system bin/"officecli", "create", "test.docx"
    assert_path_exists testpath/"test.docx"
    system bin/"officecli", "add", "test.docx", "/body", "--type", "paragraph", "--prop", "text=Hello from Homebrew"
    output = shell_output("#{bin}/officecli view test.docx text --json")
    assert_match "Hello from Homebrew", output
  end
end
