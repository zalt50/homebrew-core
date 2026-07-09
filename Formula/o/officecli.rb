class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.133.tar.gz"
  sha256 "9156dcf857c7d876707f03b1bcaa001a81f0114a82d902b577ad020e7d573ee9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d39e87a309bbd29a6fb0a45defa2e52b3226499d0c513b3a7be0dbe1beb7998"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d5600e3432c595b447fb8ddc7065e5769dc1f59dfaba8d89ee5f73b8ac630b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488bcaa52c1497b773f7e78d18c675c55de6442f51e62eacf622d6e48f74f6ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2cd2b57b67dff92dfaae240828811e8d5dde8d1ebbc4b236dbb2439f35e2c64"
    sha256 cellar: :any,                 arm64_linux:   "3ffa9873dd3253b0fa2a285bad3363261bf3e1bca85475c25b332774f0b31221"
    sha256 cellar: :any,                 x86_64_linux:  "ea8f5f4273fda11a556872822f07c5636bd58c776d0ca4a6751b8fd47f61cb25"
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
