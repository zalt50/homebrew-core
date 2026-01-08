class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1335.tar.gz"
  sha256 "9663a77232adf2740945bb45c47cbd3b5dc8eb9e40ac69121ea1c69089029650"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fd6b68594c3f592e4c256d5f767a4fb9297ec67ad6b2723ee7b62144305a07d"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
