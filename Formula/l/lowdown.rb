class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_2_0_4.tar.gz"
  sha256 "d366866f34de35a64a366efcf15dd787960ca25d986bb8780fb04a4306999eec"
  license "ISC"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f0f66ad467ae9149a73953e2bbfe58da4eb6056357ffed64f1d3a8bfe1e4319"
    sha256 cellar: :any,                 arm64_sequoia: "d27c4fdd19aec3b062d8d3162b1034de6af7224d3574ba1e3b8b2db3bd00f42b"
    sha256 cellar: :any,                 arm64_sonoma:  "22b3f1bee02bc72f745080561fd2f6f0995e04357138f1f33cb570158106109f"
    sha256 cellar: :any,                 sonoma:        "3f665399d8b0a1d688c64e5e10652dc6ddd1afd38b9bbadebc496299284adbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e4ec4b0c90f02891833118478258195d578109a3774308439760f0447671a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a312ed190ac61e031d5761fe9e97e43e84134449d0fdfab50461c3868e45a153"
  end

  depends_on "bmake" => :build

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
