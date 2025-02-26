class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.29.0.tar.xz"
  sha256 "28432d995257c4626fe0fb2091f588df6eed98e9571419e72c83bc23372e6b89"
  license "GPL-2.0"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "3485f4c80d9b510e4f749be31cf76d8287716f279aafbe094951b02817a144ad" => :catalina
    sha256 "52903ac15430cf14d29cb95c6aa1e118733fbb36a5ecf9bcbb51e63f3e4976b0" => :mojave
    sha256 "eececd54ad97593286e29f032d1e306c27bfd1d91e36dbebf4d194c851c2e5f7" => :high_sierra
    sha256 "67fd903f37f46b664715e8b9ceedf4a896174378b9ea78bea09da51129a8ac3d" => :x86_64_linux
  end

  depends_on "tcl-tk"

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk"].opt_bin
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin/"git-gui", "--version"
  end
end
