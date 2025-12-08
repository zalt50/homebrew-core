class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich command-line audio/video downloader"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/14/77/db924ebbd99d0b2b571c184cb08ed232cf4906c6f9b76eed763cd2c84170/yt_dlp-2025.12.8.tar.gz"
  sha256 "b773c81bb6b71cb2c111cfb859f453c7a71cf2ef44eff234ff155877184c3e4f"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27f792f30f3809794a601b9544b7517a25b69ae01fb80ecd76de3cf058440db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99e59ae8865c720f1edb8fe1fac42200e3ef06422c8acdebaf17cd60ba02822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3fb028b7e272aec11ee59756ebea84d8ff61d02bce5dc35eabcc0121790351"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fed8cfcc154a53b8c6d16431ae3f729469e939fdd1426e1ade66162eb5bf593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "887a387c0fc309f7438af2ad9300c3949c612b14dea0c0aa472cd95045a30c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25e2f14171cbc2880b74bee9e0c31d28a404258738deff4b997ab4bf8e47dc3"
  end

  head do
    url "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

    depends_on "pandoc" => :build

    on_macos do
      depends_on "make" => :build
    end
  end

  depends_on "node" => :build # https://github.com/yt-dlp/ejs/issues/37
  depends_on "certifi"
  depends_on "deno"
  depends_on "python@3.14"

  pypi_packages package_name:     "yt-dlp[default]",
                exclude_packages: "certifi"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "yt-dlp-ejs" do
    url "https://files.pythonhosted.org/packages/de/72/57d02cf78eb45126bd171298d6a58a5bd48ce1a398b6b7ff00fc904f1f0c/yt_dlp_ejs-0.3.2.tar.gz"
    sha256 "31a41292799992bdc913e03c9fac2a8c90c82a5cbbc792b2e3373b01da841e3e"
  end

  def install
    system "gmake", "lazy-extractors", "pypi-files" if build.head?
    virtualenv_install_with_resources
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    system bin/"yt-dlp", "https://raw.githubusercontent.com/Homebrew/brew/refs/heads/master/Library/Homebrew/test/support/fixtures/test.gif"

    system bin/"yt-dlp", "--simulate", "https://x.com/X/status/1922008207133671652"
  end
end
