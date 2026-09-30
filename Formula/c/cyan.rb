class Cyan < Formula
  include Language::Python::Virtualenv

  desc "iOS app injector and modifier"
  homepage "https://github.com/asdfzxcvbn/pyzule-rw"
  url "https://github.com/asdfzxcvbn/pyzule-rw/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "fa2ce2a9a715ef9691f77a293ad58a61a6daf170896aebf32024c0ee797fc4a4"
  license "Unlicense"
  revision 1
  head "https://github.com/asdfzxcvbn/pyzule-rw.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "c995d74dbbc3f69b2ef4a5fd7a28ee4cae4630d2d43f233eba10e8c4b94a79b1"
    sha256 cellar: :any,                 arm64_tahoe:       "3e5c57e0f56551ead62e908c0fbf91e31dccec524fa4403e1c38b8fc06ade7b3"
    sha256 cellar: :any,                 arm64_sequoia:     "3e5c57e0f56551ead62e908c0fbf91e31dccec524fa4403e1c38b8fc06ade7b3"
    sha256 cellar: :any,                 arm64_sonoma:      "3e5c57e0f56551ead62e908c0fbf91e31dccec524fa4403e1c38b8fc06ade7b3"
    sha256 cellar: :any,                 sonoma:            "5384185dc20d570688aba0840637a715c3e5a97d2f8cc8686ec4442b6bddaa01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ec4d32880cba6eb8e91bdbdfcb0c8c05ab8ab937d85c68fbe3d482960d6bd792"
  end

  depends_on "cmake" => :build # for lief
  depends_on "ninja" => :build # for lief
  depends_on "rust" => :build # for lief
  depends_on "ldid-procursus"
  depends_on "python@3.14"

  on_linux do
    depends_on "llvm"
  end

  resource "lief" do
    url "https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
    sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"

    livecheck do
      url :url
    end
  end

  def install
    venv = virtualenv_install_with_resources without: "lief"

    # https://lief.re/doc/latest/compilation.html#python-bindings
    resource("lief").stage do
      venv.pip_install Pathname.pwd/"api/python"
    end

    # Keep only tool binaries for the current OS/architecture pair.
    tools_arch = (!OS.mac? && Hardware::CPU.arm64?) ? "aarch64" : Hardware::CPU.arch.to_s
    tools_root = venv.site_packages/"cyan/tools"
    tools_os_dir = tools_root/OS.kernel_name
    tools_dir = tools_os_dir/tools_arch
    rm_r(tools_root.children.select(&:directory?) - [tools_os_dir])
    rm_r(tools_os_dir.children.select(&:directory?) - [tools_dir])

    # Replace prebuilt binaries
    tools_dir.each_child do |tool|
      cmd = tool.basename.to_s
      rm(tool)
      next if cmd == "insert_dylib" # has no license so fall back to LIEF

      replacement = if cmd == "ldid"
        formula_opt_bin("ldid-procursus")/cmd
      elsif OS.linux?
        formula_opt_bin("llvm")/"llvm-#{cmd.tr("_", "-")}"
      else
        DevelopmentTools.locate(cmd)
      end
      odie "Unable to find replacement for prebuilt #{cmd}!" if replacement.blank? || !replacement.exist?
      ln_s replacement.relative_path_from(tools_dir), tools_dir/cmd
    end
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cyan --version")

    # Generate a .cyan configuration file and verify it's a valid zip
    system bin/"cgen", "-o", testpath/"test.cyan", "-n", "TestApp", "-v", "1.0"
    assert_path_exists testpath/"test.cyan"
    assert_match "config.json", shell_output("zipinfo -1 #{testpath}/test.cyan")
  end
end
