class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1378.tar.gz"
  sha256 "509c8b081153a7b9ff08d6ddf0a681c0ab5190e1e336ef2e9748b801bdb9c59e"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "509050efede2c1f6b6c2e0ec12364d3700ef8ea233d493c827941a5dc0f8b162"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
