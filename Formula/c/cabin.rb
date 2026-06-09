class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.15.0.tar.gz"
  sha256 "9f8b4904c1d4072cddb3f8316cde694cb55791bfb817b1f5818f49f1d156ded6"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ceb0df820b6831bad382ee05ec258c8170c9a4f6ed52faac9e42928bc3e99d10"
    sha256 cellar: :any,                 arm64_sequoia: "4141bb5f2b68fe40ac121235ca06f81c0eb0b22bdeb00b9cb9c925eaa98a947f"
    sha256 cellar: :any,                 arm64_sonoma:  "d3dcc5269af91e7a87c11ccb90ba7262e5f4a2d887dc9152ba6422fad66d9977"
    sha256 cellar: :any,                 sonoma:        "20944f5509556bde7cfcbcab5829f30b62ea286b675bf06450e2676751dbbd17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21f009801cb40282ccb9374cffc72a5af2e2b4f7b1d9c204ad952cfffbf5167f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6308c79867c1290e4929b6e4ebf05b6b8cbd958f37fae619663ad954fb4fd8"
  end

  depends_on "rust" => :build
  depends_on "ninja" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cabin")
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello from Cabin", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end
