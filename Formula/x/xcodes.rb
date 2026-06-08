class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.0.1.tar.gz"
  sha256 "9a283925d85a41f483997f43213738e9b12a091bf94da20b0f94fe990903725d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfc27a53e26ae6745593dbf7acb43f6165ddf918cfa1a2bac73666f974c7ba3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0d1d4136c44d6bce3a29a6161d91282397175b811d8346486ff281267106f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb68620e49151d770433566d23d52a2605a0b9783d0f957c9fa3deda6825cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79aea527da63cec15cc7e775b1a380f446ac096b425915e281f8dee6ba60ac74"
    sha256 cellar: :any_skip_relocation, sonoma:        "147e32b89cab5d9e267170902e4a858b00fd45f0cb8b2f2b43ae98a5c3e3a1ae"
    sha256 cellar: :any_skip_relocation, ventura:       "c374aa5034bb5d66ec537b6096318472a9f49f584e4a727647c44962fb504183"
  end

  depends_on xcode: ["16.4", :build]
  depends_on :macos

  uses_from_macos "swift"

  resource "XcodesKit" do
    url "https://github.com/XcodesOrg/XcodesKit/archive/refs/tags/v1.0.3.tar.gz"
    sha256 "b8b1740467752421515cc741de2e066f104c66ac0c70fc8e7676816261c37685"
  end

  resource "XcodesLoginKit" do
    url "https://github.com/XcodesOrg/XcodesLoginKit/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "d0e25a892b03c272a533f7e9ea7f9ea9f6bbd34c51dbfef1d0069f5787e154a6"
  end

  def install
    (buildpath/"xcodes").mkpath
    mv Dir["*"] - ["xcodes"], buildpath/"xcodes"

    resource("XcodesKit").stage(buildpath/"XcodesKit")
    resource("XcodesLoginKit").stage(buildpath/"XcodesLoginKit")

    cd "xcodes" do
      system "swift", "build", "--disable-sandbox", "--configuration", "release"
      bin.install ".build/release/xcodes"
      generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
    end
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
