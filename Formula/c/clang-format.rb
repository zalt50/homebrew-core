class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz"
    sha256 "d9022ddadb40a15015f6b27e6549a7144704ded8828ba036ffe4b8165707de21"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/clang-21.1.8.src.tar.xz"
      sha256 "6090e3f23720d003cdd84483a47d0eec6d01adbb5e0c714ac0c8b58de546aa62"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/cmake-21.1.8.src.tar.xz"
      sha256 "85735f20fd8c81ecb0a09abb0c267018475420e93b65050cc5b7634eab744de9"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/third-party-21.1.8.src.tar.xz"
      sha256 "7fe99424384aea529ffaeec9cc9dfb8b451fd1852c03fc109e426fe208a1f1a7"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fabb507e8eabd59ec12f5a3b1879e3014c5b166680f6c22ebd98814d649dd649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9d0baff6790013a363eabb000a94ae9562c247e4d0364ca70ee20b188e7a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52c1881d00f096232f5286cfc84bacbb2ca44f977b532e0073151f48d52cbe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f42f7cb2edff4565a8ff4f724215e024f15ae5d8d16dbfb2b823a8fbdae916e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0704788c6f72c346d680d93886b09cc5e34b2046b6a561226c03a372a4180f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0a0aadce0197fe41d163d7c17d49e869cb00442c424eeda81367edc6f0da4f"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char* args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
