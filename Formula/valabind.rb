class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  license "GPL-3.0"
  revision 4
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "c5ad6fe97fa944521c3848f282a940aa3f37d22bc96a472d6f320715f679b38b" => :catalina
    sha256 "e120768e4de31c6d5efcfd3e09eacf59c9b8d2388f3a402a296fc13a50c35263" => :mojave
    sha256 "90ee3663f74b52b5efb182792bbb4bd76780929bc7444dd319dcf51d27888390" => :high_sierra
    sha256 "79291b34f041db65c837dab983807a658bfd715fc9d001673f7597c38276b6f9" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Vala 0.48 compatibility
  patch do
    url "https://github.com/radare/valabind/commit/9d4fb181e24346a8c5d570290fa9892ce10c8c3b.patch?full_index=1"
    sha256 "817e68b784728102e7f182819e750af9a8d4338ded0517e426604a3561949c9a"
  end

  def install
    unless OS.mac?
      # Valabind depends on the Vala code generator library during execution.
      # The `libvala` pkg-config file installed by brew isn't pointing to Vala's
      # opt_prefix so Valabind will break as soon as Vala releases a new
      # patchlevel. This snippet modifies the Makefile to point to Vala's
      # `opt_prefix` instead.
      vala = Formula["vala"]
      pre_ver = vala.prefix(vala.version)
      inreplace "Makefile",
                /^VALA_PKGLIBDIR=(.*$)/,
                "VALA_PKGLIBDIR_=\\1\nVALA_PKGLIBDIR=$(subst #{pre_ver},#{vala.opt_prefix},$(VALA_PKGLIBDIR_))"
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
