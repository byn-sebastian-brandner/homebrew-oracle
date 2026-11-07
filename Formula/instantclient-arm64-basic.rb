# A formula that installs the Instant Client Basic package.
class InstantclientArm64Basic < Formula
  desc "Oracle Instant Client Basic for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-basic-macos.arm64-23.26.2.0.0.dmg"
  sha256 "c3c4fce37a557192322717c1a8422fe098fc829a41f382f57a288b24ad6ba11e"

  conflicts_with "instantclient-arm64-basiclite"

  def install
    lib.install Dir["*.dylib*"]
  end
end
