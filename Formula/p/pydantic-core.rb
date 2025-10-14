class PydanticCore < Formula
  include Language::Python::Virtualenv

  desc "Core functionality for Pydantic validation and serialization"
  homepage "https://github.com/pydantic/pydantic-core"
  url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
  sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0835f8d08862c41a586d622a9bc300fc7d192b6f9affe960716dc90025342d4e"
    sha256 cellar: :any,                 arm64_sequoia: "e302c527c889c295e81d561c8fc9c4f50d805be6292f7ff3bffe293ff4159876"
    sha256 cellar: :any,                 arm64_sonoma:  "38fb30ff701c46471a244bf761d071ac36c54c765f502484d29a99efaa0029c4"
    sha256 cellar: :any,                 sonoma:        "9b0be00237836a31c35e63515c6fdbae6863d8e6fa4fd6a6372abac6e8fed40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f15ad8e66fb0f290277858daaaf136437ca0936ae75d8d56441365d7e0aff9c9"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    pythons.each do |python3|
      resource("typing-extensions").stage do
        system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", "import pydantic_core;"
    end
  end
end
