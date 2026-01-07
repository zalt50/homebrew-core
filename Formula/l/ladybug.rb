class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bc23c419640ee513dc35881828d8df6221558329eb10b15b8aadae0ae61d5b0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceece6db85d3533e47d7011ae9c3a1bf80941e9b8d18b9b98f0b595cd390837c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423d35c404ae16aaf9f5e36d958805394752e017720cd8f6ef14ed696679aafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6e88f5a8d5e1ac2bf53c423f3ac62568f985265e1bd493fd1ca1f3f5a88258"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f389ab126ee8bc77f346dd8204f4747f9445d1b94f1db7ed89b3846b42d9bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41bf8b2fa22ebe17ed42aa593eb8bd66675a8e99e11d3a4c6c349bff8d4982da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4baa5b5b27e5492048401dea171e66dd8dd13b04ffd0c8cc628b095a6f585f"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tools/shell/lbug"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end
