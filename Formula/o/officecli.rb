class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.119.tar.gz"
  sha256 "18eb61de5b2afd2c54ab76b64b92b61f3979a1dec27f814e42dbd797941c3c7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afdebd4ac3c8e812561672c25e1dd0fcb9fe7701afb66149e25ad3803b07934f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe39654dff0c91241d148ee0d9a6e8c58daf65d65d71873a476c28888387203a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d68657ebacc488329246d875acea352333ce52b05cf0594617899f9d17ceed96"
    sha256 cellar: :any_skip_relocation, sonoma:        "b96de46107154fcf3ac8403e911153c2d4966b89bf177d1b1270f4a4bd91d8e5"
    sha256 cellar: :any,                 arm64_linux:   "d678403bc461fc7dc68f484604d497a560a918ff2ecda7e7b3004442c3140253"
    sha256 cellar: :any,                 x86_64_linux:  "679f2b5773be14b826622611c7d9e83f766530b3fcb4f9d456e094013a6df0f1"
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
