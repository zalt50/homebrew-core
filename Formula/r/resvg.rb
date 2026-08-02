class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/linebender/resvg"
  url "https://github.com/linebender/resvg/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "f94424d043f8e13e7e1d987810e4fdc42e88fd72916daca8bebcdedc4cc586db"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/linebender/resvg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e2c02e78cf6ee3f5671f624b6e3c63e327a34804f3b7d22d42f05a6f1639f6fe"
    sha256 cellar: :any, arm64_sequoia: "8fa6155415714e2bd6548504f813ca102e82977269a8e2a49542e7b734eb247f"
    sha256 cellar: :any, arm64_sonoma:  "8227b370b52bdd99f6c4bb8f27605dfe8e293414c391e50fa3733f8aae190b3e"
    sha256 cellar: :any, sonoma:        "ad8ea81b287bb5625d22bdc6873147b1078e45921a733443c3b677eb52e50834"
    sha256 cellar: :any, arm64_linux:   "7771286fed4fd43d7127805ae8e990a9d8bbf761a14120b1a5243b5f9a8da14e"
    sha256 cellar: :any, x86_64_linux:  "193eb64afd3efca3c188d3cb50899db7651ad88fecbdae498be69e8f45e47162"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/usvg")
    system "cargo", "install", *std_cargo_args(path: "crates/resvg")

    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "crates/c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"circle.svg").write <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    SVG

    system bin/"resvg", testpath/"circle.svg", testpath/"test.png"
    assert_path_exists testpath/"test.png"

    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_path_exists testpath/"test.svg"

    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <resvg.h>

      int main(int argc, char **argv) {
        resvg_init_log();
        resvg_options *opt = resvg_options_create();
        resvg_options_load_system_fonts(opt);

        resvg_render_tree *tree;
        int err = resvg_parse_tree_from_file(argv[1], opt, &tree);
        resvg_options_destroy(opt);
        if (err != RESVG_OK) {
            printf("Error id: %i\\n", err);
            abort();
        }

        resvg_size size = resvg_get_image_size(tree);
        int width = (int)size.width;
        int height = (int)size.height;

        printf("%d %d\\n", width, height);
        resvg_tree_destroy(tree);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs resvg").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "160 35", shell_output("./test #{test_fixtures("test.svg")}").chomp
  end
end
