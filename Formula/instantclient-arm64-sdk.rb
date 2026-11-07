# A formula that installs the Instant Client SDK package.
class InstantclientArm64Sdk < Formula
  desc "Oracle Instant Client SDK for Apple Silicon"
  homepage "https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html"

  url "https://download.oracle.com/otn_software/mac/instantclient/2326200/instantclient-sdk-macos.arm64-23.26.2.0.0.dmg", using: :nounzip
  sha256 "5ee0dffe7ff0ac55eea198ef69681cc729fc7fdf17cc9089f8bfd5d93c51413e"

  depends_on "sevenzip" => :build

  def install
    # Homebrew cannot mount DMGs inside its build sandbox (hdiutil attach fails
    # with "Device not configured"), so extract the image with 7-Zip instead.
    system Formula["sevenzip"].opt_bin/"7zz", "x", "-y", Dir["*.dmg"].first

    lib.install ["sdk"]
    # Header files can not be moved out of sdk/include because some software
    # (e.g. ruby-oci8) expects to find them there. Link the header files
    # instead. Only the OCI headers (oci.h and everything it includes) are
    # linked, so generic names like ldap.h, xml.h or xa.h do not shadow other
    # libraries' headers in the Homebrew prefix.
    Dir[lib.join("sdk/include/{oci,or,nz}*.h")].each do |header_file|
      include.install_symlink header_file
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <oci.h>

      int main()
      {
        ub4 od = OCI_DEFAULT;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    system "./test"
  end
end
