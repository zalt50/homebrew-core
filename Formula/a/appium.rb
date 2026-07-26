class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.6.0.tgz"
  sha256 "ea722c272d117ffac7e265e6565651f3835efbcea670f82a16f4e75de120b76e"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "e3685b91dad7c4fa433f50122b43874fd48ece23c63580129abc298c807db359"
    sha256               arm64_sequoia: "4e9927e09ee7fb33a0f34678289b4846e4060235e14162c783262badbded008f"
    sha256               arm64_sonoma:  "85468f85ecf701954bb07bd9d73a0a55a12e60073afd72328cd7351201e91e05"
    sha256               sonoma:        "f4862705105ab3d2f3040cdfc1be1d25ab6fe7048bf5df4e99e80a4fef17e0fd"
    sha256 cellar: :any, arm64_linux:   "4bf8c263c383ea30d779af0754860f468690ba79a707b4400a42bb6062754c76"
    sha256 cellar: :any, x86_64_linux:  "c02df44b4a10041a9784ca8e115dbc23872457807283513406d5516e3530b030"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.0.tgz"
    sha256 "19b87e2ce3a77fec0121ac97d7db088aae28aacfff481adab50d5f61b70e68f4"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    ENV["APPIUM_SKIP_CHROMEDRIVER_INSTALL"] = "1"

    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appium/node_modules"
    rm_r(node_modules.glob("bare-{path,fs,os,url}/prebuilds/*"))

    # Build `sharp` from source against brewed `vips`
    rm_r(node_modules.glob("@img/sharp-*"))
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # `sharp` resolves its native binary from `@img`, so link the source build there.
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/appium/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
