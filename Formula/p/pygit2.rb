class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/6c/4b/da6f1a1a48a4095e3c12c5fa1f2784f4423db3e16159e08740cc5c6ee639/pygit2-1.19.0.tar.gz"
  sha256 "ca5db6f395a74166a019d777895f96bcb211ee60ce0be4132b139603e0066d83"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8856072e6e36999f9c33a05f072b7f37bcd6afcf09ce03dd4d69938e412d0ba7"
    sha256 cellar: :any,                 arm64_sequoia: "fce50c61fa6d6cba0d7b8a8128371fa0e946432dbd4a1891b0b7b6e31823fe4e"
    sha256 cellar: :any,                 arm64_sonoma:  "cf34fcce007c0fa83bb0720edc874c7fe0640412868ae89c7c2799d0055eaecd"
    sha256 cellar: :any,                 sonoma:        "eb3b54cf85b5968450ab0654aa60aacd1c04792e6dfc2db43b893687118ba26a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06fad0066edd886d161f2803a312db320ba0f4b670ff4ccd1889d0d19d5c6d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca7588afdf5a5f97d58ca4000bbe89471c3f7437ca79bf28593d7f0db687dbf"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python3|
      pyversion = Language::Python.major_minor_version(python3).to_s

      (testpath/pyversion/"hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python3, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath/pyversion}', False) # git init

          index = repo.index
          index.add('hello.txt')
          index.write() # git add

          ref = 'HEAD'
          author = pygit2.Signature('BrewTestBot', 'testbot@brew.sh')
          message = 'Initial commit'
          tree = index.write_tree()
          repo.create_commit(ref, author, author, message, tree, []) # git commit
        PYTHON

        system "git", "status"
        assert_match "hello.txt", shell_output("git ls-tree --name-only HEAD")
      end
    end
  end
end
