class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.6.tgz"
  sha256 "3cfd9681aa737c07b7444910c3b4d88a81af7a4ac8c7d3b116a987b47bbd6483"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "54fee23881afb21bc545e1f9584d31aff034da88b662f3f04c8a905c12f572c7"
    sha256 cellar: :any, arm64_sequoia: "54fee23881afb21bc545e1f9584d31aff034da88b662f3f04c8a905c12f572c7"
    sha256 cellar: :any, arm64_sonoma:  "54fee23881afb21bc545e1f9584d31aff034da88b662f3f04c8a905c12f572c7"
    sha256 cellar: :any, sonoma:        "f4efe4d2efd73fe4724ae245aa9895fb64b7a73250dbc67a8e3227758e47183d"
    sha256 cellar: :any, arm64_linux:   "cf07a4fd84e007514892f1ed04d3483f9fb2a6e9d7e8a0bf199f259b15f27e4d"
    sha256 cellar: :any, x86_64_linux:  "861812b6ce9c583edfe05f567e83aa4e3b0d60c003a09d5d3ac10e8b7372fd5c"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.1.tgz"
    sha256 "9091c2a5e57dae6ae5a0ca9c42d6127586bed4168cc1a342c95b64e61efd60af"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end

    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    # `node-addon-api` 8 needs C++17, which the older `sharp` predates
    inreplace node_modules/"icon-gen/node_modules/sharp/src/binding.gyp" do |s|
      s.gsub! "'-std=c++0x'", "'-std=c++17'"
      s.gsub! "'c++11'", "'c++17'"
    end

    # `icon-gen` pins an older `sharp` whose bundled `vips` shares the brewed soname
    { node_modules => "build", node_modules/"icon-gen/node_modules" => "install" }.each do |dir, script|
      rm_r(dir.glob("@img/sharp-*/lib/*.node"))
      rm_r(dir.glob("@img/sharp-libvips-*/lib/libvips-cpp.*"))
      cd dir/"sharp" do
        system "npm", "run", script
        rm_r("src/build/Release/obj.target")
      end
    end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

    begin
      io = IO.popen("#{bin}/pake index.html --use-local-file --iterative-build --name test")
      sleep 5
    ensure
      Process.kill("TERM", io.pid)
      Process.wait(io.pid)
    end

    assert_match "No icon provided, using default icon.", io.read
  end
end
