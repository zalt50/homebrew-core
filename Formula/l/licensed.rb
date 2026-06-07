class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.1.0",
      revision: "5cefad36349e5798ab0e4e33551907ff999ccbaa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea77d11cb8ea2da19a84ab0f0364879377e11d303aa963d0ac049bf1703cbbd5"
    sha256 cellar: :any,                 arm64_sequoia: "82a43ae41ae886071174c26305626fcbd3d73345e84dc834640c66d5aedc6d8e"
    sha256 cellar: :any,                 arm64_sonoma:  "c4956552d915a6d6e92587842fdaea142c15bbaba25e90bb938829a6b1893cad"
    sha256 cellar: :any,                 sonoma:        "7af95dd4e135fca493ff97db9ff2a7deeef984d9a978b3f3556e7e3cb7a69695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f68d0c9c90ba091329670f3c55db2dab668310c0706bc549cb4ddd4a1ac484b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f587002eec90446e70bfacce15a00a64481313940db75c5cf5cb983271e3aa36"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "ruby"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # TODO: Remove resource when there is a new release
  resource "rugged" do
    url "https://github.com/libgit2/rugged.git",
        tag:      "v1.9.0",
        revision: "5b28daf1fca547f875489650345bf9067e78fa25"

    # Backport fix to use brew libgit2
    patch do
      url "https://github.com/libgit2/rugged/commit/5fee507fef1a322efabceee6f938195795d90eea.patch?full_index=1"
      sha256 "4495f461391564df09ece50e7eb16bc8242af11c7a732180f9ce76e8b824e660"
    end
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    resource("rugged").stage do |r|
      system "gem", "build", "rugged.gemspec"
      system "gem", "install", "--ignore-dependencies", "rugged-#{r.version}.gem", "--", "--use-system-libraries"
    end

    system "bundle", "config", "set", "build.nokogiri", "--use-system-libraries"
    system "bundle", "config", "set", "build.rugged", "--use-system-libraries"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensed version").strip

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath/".licensed.yml").write <<~YAML
      name: 'test'
      allowed:
        - mit
    YAML

    assert_match "Caching dependency records for test", shell_output("#{bin}/licensed cache")
  end
end
