# A formula that installs the Instant Client SQLPlus package.
class InstantclientArm64Sqlplus < Formula
  desc "Oracle Instant Client SQLPlus for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-sqlplus-macos.arm64-23.26.2.0.0.dmg", using: :nounzip
  sha256 "c3b10537194a5267a3ed18d09fddae1f864191e0de25ad78042940bb82496294"

  depends_on "sevenzip" => :build

  option "with-basiclite", "Depend on instantclient-basiclite instead of instantclient-basic."

  depends_on "instantclient-arm64-basic" if build.without?("basiclite")
  depends_on "instantclient-arm64-basiclite" if build.with?("basiclite")

  def install
    # Homebrew cannot mount DMGs inside its build sandbox (hdiutil attach fails
    # with "Device not configured"), so extract the image with 7-Zip instead.
    system Formula["sevenzip"].opt_bin/"7zz", "x", "-y", Dir["*.dmg"].first

    if HOMEBREW_PREFIX.to_s != "/usr/local"
      system DevelopmentTools.locate("install_name_tool"), "-add_rpath", HOMEBREW_PREFIX/"lib", "sqlplus"
    end
    lib.install Dir["*.dylib"]
    bin.install ["sqlplus"]
    if MacOS.version >= :catalina
      bin.env_script_all_files(libexec, "DYLD_LIBRARY_PATH" => HOMEBREW_PREFIX/"lib")
    end
  end
end
