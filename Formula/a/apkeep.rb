class Apkeep < Formula
  desc "Command-line tool for downloading APK files from various sources"
  homepage "https://github.com/EFForg/apkeep"
  url "https://github.com/EFForg/apkeep/archive/refs/tags/1.1.0.tar.gz"
  sha256 "20407a9420cb2a47a8801d744a8ebeefff5d0cc62c5a956445724fb5cde5897c"
  license "MIT"
  head "https://github.com/EFForg/apkeep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69f589eb3e8e173289272229b5361dc102ed379682699507e038cd2fe7d25410"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b0b3044c728dc7e348c3183c19a0c0771e055570d94c8d98b439d3be20f48c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7bb0009f121096812f482f7f476c50546346daecd2d0a3aea5c19a9eb81d96e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e7900765e83e8c263db7346ca8e5d9a810098bdb165494f6c0305833ad5efd22"
    sha256 cellar: :any_skip_relocation, sonoma:            "1b83813507b5f61fffc83f85f7cd04cd71e304759daa741ea0011977e551a5f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9135054d2ddc100bb59462b0f5d76311cd561611425eac9d0f2c68ce07fdf86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c5e13c382bd54d59495c0dc10e09f52f65a7a0ab2560dc7463b89537e455b542"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apkeep --version")

    # hello world apk, https://play.google.com/store/apps/details?id=dev.egl.com.holamundo&hl=en_US
    system bin/"apkeep", "--download-source", "apk-pure", "--options", "acknowledge_dangers=true",
           "--app", "dev.egl.com.holamundo", testpath
    assert_path_exists "dev.egl.com.holamundo.xapk"
  end
end
