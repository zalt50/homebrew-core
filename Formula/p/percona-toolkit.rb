class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://downloads.percona.com/downloads/percona-toolkit/3.7.1-4/source/debian/percona-toolkit_3.7.1.orig.tar.gz"
  version "3.7.1-4"
  sha256 "c4a2502bba0118c0e4a72faa58a3174d793431e65d9aee6c260eae49216ead14"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/percona/percona-toolkit.git", branch: "3.x"

  livecheck do
    url "https://www.percona.com/wp-admin/admin-ajax.php", post_form: {
      action:     "percona_downloads",
      product_id: "percona-toolkit",
    }

    strategy :json do |json|
      json["data"]["versions"][0]
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05b3f3f28f2b13b7d4f7ba1b325d82a617a6d27447d6bc6262d5f00c735bae40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80bef441d4e161079ff09264e1c60b8de590aa1ffea7780fd1bd0bf393b9b4e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4361cdd519c35383e8670636c42ca57617136638f85f1e5dc75cfce9be3b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c89c731b466953de715f23f17798208ee16137d87fabd7d121f041ba445dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac3d2a5ec59955b3a7296e6adc223e02fc63f23328686245f885695d9da979f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989cfa41ec604acfb78a5625b686f0c0ab09b1d9b3a9f3d3db9855fa7c3c24f7"
  end

  depends_on "go" => :build
  depends_on "perl-dbd-mysql"

  uses_from_macos "perl"

  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end
  end

  def install
    ENV.prepend_path "PERL5LIB", formula_opt_libexec("perl-dbd-mysql")/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                      "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none",
                                      "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp

    # Test a command that uses a native module, like DBI.
    assert_match version.to_s, shell_output("#{bin}/pt-online-schema-change --version")
  end
end
