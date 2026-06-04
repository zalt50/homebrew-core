class VimClassic < Formula
  desc "Vim 8 long term support version with no LLM-generated code"
  homepage "https://vim-classic.org/"
  url "https://git.sr.ht/~sircmpwn/vim-classic/archive/v8.3.0.tar.gz"
  sha256 "6e1c97c8269e9354bbc474f0efa7e1e0b23fcdb6075067474d731a9bfac6e8ef"
  license "Vim"

  # Homebrew Ruby installs (4.x) currently cause a linker error with vim-classic,
  # so we don't try building in Ruby interpreter support.
  depends_on "gettext" => :build
  depends_on "lua" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  uses_from_macos "perl" => [:build, :test]
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  def extra_deps = deps.select { |dep| dep.build? && dep.test? }

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

    ENV.append_to_cflags "-mllvm -enable-constraint-elimination=0" if DevelopmentTools.clang_build_version == 1600

    # Allow dynamically loading formulae libraries when not linked
    extra_deps.each do |dep|
      extra_rpath = dep.to_formula.opt_lib
      extra_rpath = rpath(target: extra_rpath) if OS.mac? # cannot use $ORIGIN
      ENV.append "LDFLAGS", "-Wl,-rpath,#{extra_rpath}"
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
           "--mandir=#{man}",
           "--enable-multibyte",
           "--with-tlib=ncurses",
           "--with-compiledby=Homebrew",
           "--enable-cscope",
           "--enable-terminal",
           "--enable-perlinterp#{"=dynamic" unless OS.mac?}",
           "--enable-python3interp=dynamic",
           # Homebrew Ruby installs (4.x) currently cause a linker error with vim-classic,
           # so don't try building in Ruby interpreter support.
           # "--enable-rubyinterp=dynamic",
           "--disable-gui",
           "--without-x",
           "--enable-luainterp=dynamic",
           "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    system "make", "install", "prefix=#{prefix}"
    bin.install_symlink "vim" => "vi"
  end

  def caveats
    "Additional features can be enabled by installing: #{extra_deps.map(&:name).join(", ")}"
  end

  test do
    (testpath/"commands.vim").write <<~VIM
      :perl $curbuf->Append(0, "hello perl")
      :lua vim.buffer():insert("hello lua")
      :wq
    VIM
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello perl\n\nhello lua", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
