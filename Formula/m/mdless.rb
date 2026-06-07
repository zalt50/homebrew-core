class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.65.tar.gz"
  sha256 "a22222540685a4f973ad6b8739c2b6f576ff3537e42f0370819cc9f3fffef49d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cf16453b58d21154b5a3715b4f2b7c3627ab7d17b2f9e6cd977a76ca83eee64"
    sha256 cellar: :any,                 arm64_sequoia: "012c94f712e72a9adfbc0b7b812c6d7e57f8e36f039cc65d63f85e9a3c55bab6"
    sha256 cellar: :any,                 arm64_sonoma:  "783902b6ce58aaccaf249859483e9eeefcac6e0548653af05cba8cd6108951f8"
    sha256 cellar: :any,                 sonoma:        "82e566d65f4610b2a4f451675ba00cbd2df7b756bed2be15f9a6bf9a9e4e7493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e49abff2805c4b46de61434fbd1c4f2647881e5b9dcb97119b9afa5b100dab66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f8a5c0d2ae98e656ae881c66a8276d5ef014f51070826eb37f0227f75bb7f4"
  end

  depends_on "ruby"

  # List with `gem install --explain mdless --platform ruby -v #{version}`
  resource "tty-which" do
    url "https://rubygems.org/gems/tty-which-0.5.0.gem"
    sha256 "5824055f0d6744c97e7c4426544f01d519c40d1806ef2ef47d9854477993f466"
  end

  resource "tty-cursor" do
    url "https://rubygems.org/gems/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "tty-screen" do
    url "https://rubygems.org/gems/tty-screen-0.8.2.gem"
    sha256 "c090652115beae764336c28802d633f204fb84da93c6a968aa5d8e319e819b50"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-4.7.0.gem"
    sha256 "dba5896715c0325c362e895460a6d350803dbf6427454f49a47500f3193ea739"
  end

  resource "redcarpet" do
    url "https://rubygems.org/gems/redcarpet-3.6.1.gem"
    sha256 "d444910e6aa55480c6bcdc0cdb057626e8a32c054c29e793fa642ba2f155f445"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~MARKDOWN
      # title first level
      ## title second level
    MARKDOWN
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
