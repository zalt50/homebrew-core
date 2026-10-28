class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/refs/tags/v1.14.tar.gz"
  sha256 "b99cc0615ea41d3538aee068c998413aef12c3562684167905cc832bb77ef361"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "dbf1d6fa306b45dd024bcb4affa6ecdae29269e2de18b6d97c9ed0a7bba5eeea"
    sha256 cellar: :any_skip_relocation, ventura:      "77beee69a1b3748ed9f627c31b5ee91bd6914ee614e6b49fc027e1ab76f3ce86"
    sha256 cellar: :any_skip_relocation, monterey:     "df21345c80cded7b9d732d1158a904bd0fe8118bd91da58fe99d3614c02f1e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d0f7c8987f103a1002a96a696df47d99765c6604ab91630121a0e1209c6afbb"
  end

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-darwinarm64.tar.gz"
        sha256 "c26d879053c6691182da779ceeadb7fd4e2d63d04a4a603cfff5a2f124be0211"
      end
      on_intel do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-darwinx86.tar.gz"
        sha256 "f69a70ff50677877e989e36818f0baa19fa4cb186440a7984a9ccdcd07236276"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-linuxarm64.tar.gz"
        sha256 "766c4ef63708ea9152f4565eb59d89a79ab3ddaf852a69c0ef91633f89f61332"
      end
      on_intel do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-linuxx86.tar.gz"
        sha256 "96fff67c53b56dc67acc06e92ff1774b73401564650669c95e7c63f1200a4f5d"
      end
    end
  end

  deny_network_access!

  def install
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x86" : Hardware::CPU.arch.to_s
    suffix = Hardware::CPU.bits.to_s if Hardware::CPU.intel?

    kernel_prefix = os[0] if !OS.linux? || !Hardware::CPU.arm?
    kernel = "#{kernel_prefix}#{arch}cl#{suffix}"
    kernel_build_dir = "#{os}#{arch}#{suffix}"
    interface_database_dir_prefix = os + "-" unless OS.linux?
    interface_database_dir = "#{interface_database_dir_prefix}#{arch}-headers#{suffix}"

    resource("bootstrap").stage do
      buildpath.install interface_database_dir, "#{kernel}.image"
    end

    system "make", "-C", "lisp-kernel/#{kernel_build_dir}", "clean"
    system "make", "-C", "lisp-kernel/#{kernel_build_dir}", "all"
    system "./#{kernel}", "--no-init", "--batch",
                          "--eval", "(ccl:rebuild-ccl :full t)",
                          "--eval", "(quit)"

    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    (bin/"ccl").write_env_script(libexec/kernel, CCL_DEFAULT_DIRECTORY: libexec)
    bin.install_symlink "ccl" => "ccl#{Hardware::CPU.bits}"
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
