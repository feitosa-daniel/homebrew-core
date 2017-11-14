require "language/go"

class Tmsu < Formula
  desc "Tag your files and then access them through a nifty virtual filesystem"
  homepage "https://tmsu.org/"
  url "https://github.com/oniony/TMSU.git",
    :tag => "v0.7.0",
    :revision => "d6d69738b1287f2c89cfe45bad3d331045393eaa"

  head "https://github.com/oniony/TMSU.git"

  depends_on :macos

  unless File.exist?("/Library/Frameworks/OSXFUSE.framework")
    odie "Could not detect OSXFuse. TMSU requires Fuse."
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
      :revision => "ed69081a91fd053f17672236b0dd52ba7485e1a3"
  end

  go_resource "github.com/hanwen/go-fuse" do
    url "https://github.com/hanwen/go-fuse.git",
      :revision => "5690be47d614355a22931c129e1075c25a62e9ac"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "5f8847ae0d0e90b6a9dc8148e7ad616874625171"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "compile"

    bin.install "bin/tmsu"
    sbin.install "misc/bin/mount.tmsu"
    man1.install "misc/man/tmsu.1"
    (share/"zsh/site-functions").install "misc/zsh/_tmsu"
  end

  test do
    system bin/"tmsu", "--version"
  end
end
