class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_2_0_3.tar.gz"
  sha256 "2c6251ca35002dfc8729dd29ddbff7df700b9ca8de39f36f7a826fcfd20ef426"
  license "ISC"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "649de2546b83ee9f6072b1ea1f3df0aad0d9cb2eb7368a35c46850c982277f37"
    sha256 cellar: :any,                 arm64_sequoia: "72539b273d1f011b41a404ec609e5e5f90d95ecfed55de488ca96a599e7aa671"
    sha256 cellar: :any,                 arm64_sonoma:  "db56e9a27e486ab120cfb60b6c0c35906bebedbde3542c0228413bd2c7327659"
    sha256 cellar: :any,                 arm64_ventura: "682e3e2c5bb4100111aa12a3295758a33c9ef0fb688026730ba72c38d0e4a618"
    sha256 cellar: :any,                 sonoma:        "39ca5b7e92d47aedfd37487c61560c0bf81952682a2f210c75e430532ee0f3fb"
    sha256 cellar: :any,                 ventura:       "939b0d8f64b94d96ba9e865a89872d4f031b2c538fb20ba215f9be95ca3ab5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a643fc2ad9a4c717c3a5c507cd05cd48e31a521e8d5912c753e68745f89df2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ccef0a88b45b09cebd38dd16dff22a85e83475e036a539cbff5c7d948dcb08"
  end

  depends_on "bmake" => :build

  # Fix dylib suffix
  # https://github.com/kristapsdz/lowdown/pull/169
  patch do
    url "https://github.com/kristapsdz/lowdown/commit/79b610ca90ad7e0e20b7acf16e52a2481312810e.patch?full_index=1"
    sha256 "5bd0e774e48e7649a959553422181a8f0f7a76cdacb3775631763751f48840d4"
  end

  def install
    configure_args = %W[MANDIR=#{man} PREFIX=#{prefix}]
    if OS.mac?
      File.open("configure.local", "a") do |configure_local|
        configure_local.puts "HAVE_SANDBOX_INIT=0"
      end
      configure_args << "LINKER_SONAME=-install_name"
    end

    system "./configure", *configure_args
    system "bmake"
    system "bmake", "install", "install_libs"
  end

  test do
    expected_html = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <title></title>
      </head>
      <body>
      <h1 id="title">Title</h1>
      <p>Hello, World</p>
      </body>
      </html>
    HTML
    markdown = <<~MARKDOWN
      # Title

      Hello, World
    MARKDOWN
    html = pipe_output("#{bin}/lowdown -s", markdown)
    assert_equal expected_html, html
  end
end
