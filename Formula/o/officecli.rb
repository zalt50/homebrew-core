class Officecli < Formula
  desc "Read, edit, and automate Office documents (.docx, .xlsx, .pptx)"
  homepage "https://github.com/iOfficeAI/OfficeCLI"
  url "https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v1.0.131.tar.gz"
  sha256 "6dab395116fade41954100ddec6213c6d922a378a6443feaf6d849daaf807f06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae06c068235d4473ff337ca20148f3524b7bdac9e2de0bc714a9c9e41c766a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b3cfb0e555c431d08c89c57e436355015bc8ac982bc709e847c9e36c33956a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b0e8342919cd0f8e3cf58423d46bddff16e7507e1263d4a42839cc37a7fa1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7ca690605c4e510df98bcd9c263d79a6d7d9b2b0d704c3dd35d8fe200fd6032"
    sha256 cellar: :any,                 arm64_linux:   "b45ad57aac7733bd0a5a545166277afadbaad4b5aadb6c89d6caa3c5430b4aa0"
    sha256 cellar: :any,                 x86_64_linux:  "029171e16665099fa5c78c1179d5994dad956163890f905084c1e43758b02e37"
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
