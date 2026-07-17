class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.138.tar.gz"
  sha256 "ee8b3e17241e63290e4b6f0da9f7acf8bff8fc969022262981854b9afeae2e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "930ec7d83ded0ada7030abd21919baeb214784fe5da600d19878e531053874fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d37851fe7b0f0203124653cd3362d91227eab3927e42900503fd777ddb67da8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9596eb279aa99333279e4c59be4879a2a47e2ba709b63a56c0747e2e191c0693"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f81da9c43904113f2b8d037243ee5f51ff7ee9aa5861670936fa82f510606a2"
    sha256 cellar: :any,                 arm64_linux:   "cac5e5a1307f5151b1a45e8f76fbbc29cd4f898f32d1edc4b71b022dca405f89"
    sha256 cellar: :any,                 x86_64_linux:  "12c4319ac09923e60fc4fbb9e45e420e2932f66451cb928df00dbca850de4c59"
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
