class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20251212.tar.xz", using: :nounzip
  sha256 "06379250c91306c98cb9726af44eae5909dfdd5449f90331e904ae1221d8d5e7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61619ff6e7611219a5573a9248962b8d2b466ba5be2f65ed62cb0e6b24001112"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", "osinfo-db-#{version}.tar.xz"
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
