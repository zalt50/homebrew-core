class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/refs/tags/v1.63.tar.gz"
  sha256 "be65e5b06cdaff8ab38e339f0a30304e4721660218db0c0ab3f68636688f25c4"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  # Ignore `debian/<version>` tags
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281415695dee735e09fd941c316edf238a5f2b04c0dc91c4b1ddd079646c8235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281415695dee735e09fd941c316edf238a5f2b04c0dc91c4b1ddd079646c8235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6265ef15bfe79ba7eb98b7c726fddcf19819ffa4ee0f613af37df07d396c48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85639667a8f91888be75bf1f0fb1074b6f23adf6d3e2a4ec3048efaceed0d53e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f6265ef15bfe79ba7eb98b7c726fddcf19819ffa4ee0f613af37df07d396c48"
    sha256 cellar: :any_skip_relocation, ventura:       "85639667a8f91888be75bf1f0fb1074b6f23adf6d3e2a4ec3048efaceed0d53e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a2d8d23c361d988cb5f8f0b9e4fa18b6afbb82586c1dacbd59f8b8e842b64cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40767525dd58b22625351aef13957ca8c923e7c7aff998f0c00a92a1bdcca51d"
  end

  depends_on "gnuplot"

  uses_from_macos "perl"

  on_linux do
    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006003.tar.gz"
      sha256 "6499f09a6432cf87b133fb9580a8a9a9a6c566821346b1fdee95f7b64c0317b1"
    end

    resource "List::MoreUtils" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
      sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
    end

    resource "List::MoreUtils::XS" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
      sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "prefix=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make"
    system "make", "install"
    prefix.install Dir[prefix/"local/*"]
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
