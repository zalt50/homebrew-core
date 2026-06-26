class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.122.tar.gz"
  sha256 "c45b74dd43688dc20caac45f48492840f05b77f81d5138c06be4ac22ed281c01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48386f1605c559018a876e51106eb2945eede65c2ee0ce26e59cd263c5eeecab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fd4bf2c918329f99aca79e83c0d62e7441972bae262f166c729e6c1f16c43d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40d0527dfac7daad5b68153631be928918e5b4655fd64acb642ade8c1ef5aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "cda2ce1049cf1f297aa84d3ff026287283633122db6ca5493b0b3a6bb134bd20"
    sha256 cellar: :any,                 arm64_linux:   "5e0d3ba75bc3b5cccf2604a0b09d848f9e1c99cc7c0f922b1cb398a88457e67a"
    sha256 cellar: :any,                 x86_64_linux:  "8a4754e842485b51023fe9955ae08b8e0364899c66565ce1e1bda1d844834a4f"
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
