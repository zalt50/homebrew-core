class LttngUst < Formula
  desc "Linux Trace Toolkit Next Generation Userspace Tracer"
  homepage "https://lttng.org/"
  url "https://lttng.org/files/lttng-ust/lttng-ust-2.15.1.tar.bz2"
  sha256 "37c9b58ea7aa7bc47d6630b52ba1a48ebce095b9a196eab4ddd273d78301792d"
  license all_of: ["LGPL-2.1-only", "MIT", "GPL-2.0-only", "BSD-3-Clause", "BSD-2-Clause", "GPL-3.0-or-later"]

  livecheck do
    url "https://lttng.org/download/"
    regex(/href=.*?lttng-ust[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ae17463266ec81f0c13af2523c6eec514d908e907eca4e415b5092b4258de9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5348e0b6be2ca8554dd9bcb1bce4b4e82408f954fd9505e19f45b4a384bd6b93"
  end

  depends_on "pkgconf" => :build
  depends_on :linux
  depends_on "numactl"
  depends_on "userspace-rcu"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    cp_r (share/"doc/lttng-ust/examples/demo").children, testpath
    system "make"
    system "./demo"
  end
end
