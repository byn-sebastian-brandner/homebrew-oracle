# A formula that installs the Instant Client Tools package.
class InstantclientArm64Tools < Formula
  desc "Oracle Instant Client Tools for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-tools-macos.arm64-23.26.2.0.0.dmg"
  sha256 "7041d9165fe370cc4ce75985db1cf14fed217a8b5e3e2cfe9cce06963527b38d"

  option "with-basiclite", "Depend on instantclient-basiclite instead of instantclient-basic."

  depends_on "instantclient-arm64-basic" if build.without?("basiclite")
  depends_on "instantclient-arm64-basiclite" if build.with?("basiclite")

  def install
    lib.install Dir["*.dylib"]

    bins = %w[impdp expdp exp imp wrc sqlldr]
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      bins.each do |bin_f|
        system DevelopmentTools.locate("install_name_tool"), "-add_rpath", HOMEBREW_PREFIX/"lib", bin_f
      end
    end
    bin.install bins

    if MacOS.version >= :catalina
      bin.env_script_all_files(libexec, "DYLD_LIBRARY_PATH" => HOMEBREW_PREFIX/"lib")
    end
  end
end
