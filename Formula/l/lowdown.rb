class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-3.1.0.tar.gz"
  sha256 "1bf17678b8813fa12defa731e61c15145558b9f7f1296b0a6fdcfdda0caba468"
  license "ISC"
  compatibility_version 2
  head "https://github.com/kristapsdz/lowdown.git", branch: "master"

  livecheck do
    url "https://kristaps.bsd.lv/lowdown/snapshots/"
    regex(/href=.*?lowdown[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe8e1e3344dbc3cd2c0aa1b74815d81e1eb6ab4593379d3c2634d05402a06966"
    sha256 cellar: :any,                 arm64_sequoia: "7ab2eecbe8f5ffe11c3e31d77be3183b18a60ca2e06aee1fe582c8b85675e9c8"
    sha256 cellar: :any,                 arm64_sonoma:  "464efd261b8b65e91ceca6e140bce86caeed72df2f6ed2d8b0db8b97a93828a5"
    sha256 cellar: :any,                 sonoma:        "6ea5d37031313bb5bec5b0623486d0e5c290dcea3adf1855cb7d7268c051d705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f81db6a9741bde23c65a3875f85da875eb2a169be84fd0f884410569477b74de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99741588edcdd41f5da276b2e8abcd821aa9587bde5a04edd653495677f1ccd"
  end

  depends_on "bmake" => :build

  patch do
    url "https://github.com/kristapsdz/lowdown/commit/5c44b2cf36e56a44bfdb3f974d11c3f96fc1b563.patch?full_index=1"
    sha256 "e5dc1625fc7b8b5d9c9fa70b0f2589cfa4ee4786be874d40104a7b82e08d0857"
    type :backport
    resolves "https://github.com/kristapsdz/lowdown/issues/185"
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
