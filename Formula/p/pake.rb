class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.7.tgz"
  sha256 "93bdd93ebe316233690dc9eaabe9871db33336f52b26f07e5a487e624cb5c620"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fa7753ddc4df9c5f1905f3455522464565a812fd4dbd02082c12c290bfe4427"
    sha256 cellar: :any,                 arm64_sequoia: "b7925af1651e072d788b3d6660e8c3cbad34ddb66cee0734a25ee1351140ffc8"
    sha256 cellar: :any,                 arm64_sonoma:  "b7925af1651e072d788b3d6660e8c3cbad34ddb66cee0734a25ee1351140ffc8"
    sha256 cellar: :any,                 sonoma:        "4f0c08d1fb99a3a72bfc25bb91bdfd53be812cbfdbcc9a58796328a51bec1781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3be0e462653c6847425c66fd3e0b7a912a399c7df68b3d87e31b3dfa0f35c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf9a2b91f1273ae6125e93b664779e63596779100d664b717b30b103f89f561"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.8.0.tgz"
    sha256 "72528f1a8235a8bc19855e21cc5ae28252c276338afa73887dc7e54515bc76c5"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    rm_r(libexec.glob("#{node_modules}/icon-gen/node_modules/@img/sharp-*"))

    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
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
