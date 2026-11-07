# Homebrew Oracle

A [Homebrew][] tap for **[Oracle Instant Client][]** and **[Oracle SQL Developer][]** on **Apple Silicon** Macs
(arm64).

| Package | Type | Version | Contents |
|---------|------|---------|----------|
| `instantclient-arm64-basic` | Formula | 23.26.2.0.0 | Instant Client libraries (OCI, OCCI, JDBC-OCI) with all languages and character sets |
| `instantclient-arm64-basiclite` | Formula | 23.26.2.0.0 | Smaller alternative to Basic – English messages, a reduced set of character sets |
| `instantclient-arm64-sdk` | Formula | 23.26.2.0.0 | Header files for building software against the client (OCI) |
| `instantclient-arm64-sqlplus` | Formula | 23.26.2.0.0 | SQL\*Plus command line client (`sqlplus`) |
| `instantclient-arm64-tools` | Formula | 23.26.2.0.0 | Data Pump, Export/Import, SQL\*Loader, Workload Replay (`expdp`, `impdp`, `exp`, `imp`, `sqlldr`, `wrc`) |
| `instantclient-arm64-odbc` | Formula | 23.26.2.0.0 | ODBC driver (`libsqora`) |
| `sqldeveloper` | Cask | 26.2.0.186.2220 | Oracle SQL Developer IDE, including its own JDK |

All packages are downloaded directly from oracle.com – nothing is rebuilt or redistributed by this tap.

---

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [What gets installed where](#what-gets-installed-where)
- [Basic vs. Basic Lite](#basic-vs-basic-lite)
- [SQL\*Plus and Tools](#sqlplus-and-tools)
- [Connecting to a database](#connecting-to-a-database)
- [SQL Developer](#sql-developer)
- [Updating and uninstalling](#updating-and-uninstalling)
- [Troubleshooting](#troubleshooting)
- [Maintaining this tap](#maintaining-this-tap)
- [License](#license)

---

## Requirements

- A Mac with **Apple Silicon** (M1 or newer). Intel Macs are not supported – Oracle no longer publishes current Instant
  Client releases for macOS x64.
- [Homebrew][] installed under its default prefix `/opt/homebrew`.

## Installation

Tap the repository once:

```bash
brew tap byn-sebastian-brandner/oracle
```

Then install what you need:

```bash
# Client libraries + headers (e.g. for building database drivers)
brew install instantclient-arm64-basic instantclient-arm64-sdk

# SQL*Plus (pulls in instantclient-arm64-basic automatically)
brew install instantclient-arm64-sqlplus

# SQL Developer
brew install --cask sqldeveloper
```

Without tapping first, use the fully qualified names, e.g.
`brew install byn-sebastian-brandner/oracle/instantclient-arm64-basic`.

## What gets installed where

`$(brew --prefix)` is `/opt/homebrew` on Apple Silicon.

| Package | Location |
|---------|----------|
| Basic / Basic Lite | Libraries (`libclntsh.dylib`, `libnnz.dylib`, `libociei.dylib`, …) in `$(brew --prefix)/lib` |
| SDK | Complete `sdk/` directory in `$(brew --prefix)/lib/sdk` (headers in `lib/sdk/include`, plus demos and OTT). The OCI headers (`oci*.h`, `or*.h`, `nz*.h`) are additionally linked into `$(brew --prefix)/include`. |
| SQL\*Plus / Tools | Executables in `$(brew --prefix)/bin` |
| ODBC | `libsqora.dylib.23.1` in `$(brew --prefix)/lib` |
| SQL Developer | `/Applications/SQLDeveloper.app` |

Notes:

- The header files intentionally stay in `lib/sdk/include`: build scripts of database drivers usually look for them
  in `<instant client dir>/sdk/include`. With the layout above, `$(brew --prefix)/lib` *is* the Instant Client
  directory for those scripts.
- Only the OCI headers are linked into `include/`. Generic names shipped by the SDK (`ldap.h`, `xml.h`, `xa.h`, …) would
  otherwise shadow headers of other libraries installed via Homebrew.
- Not installed: the `.jar` files (JDBC drivers – use Maven/Gradle instead), the diagnostic helpers `adrci`, `genezi`,
  `uidrvci`, and the empty `network/admin` directory (see [Connecting](#connecting-to-a-database)).
- `ORACLE_HOME` is **not** required for Instant Client. Set `TNS_ADMIN` only if you use `tnsnames.ora` / `sqlnet.ora`.

## Basic vs. Basic Lite

|  | Basic | Basic Lite |
|--|-------|------------|
| Download size | ~137 MB | ~66 MB |
| Error messages | all languages | English only |
| Character sets | all | Unicode (AL32UTF8, UTF8, AL16UTF16), US7ASCII and Western European (WE8ISO8859P1, WE8MSWIN1252, WE8DEC) |

The two formulae **conflict** with each other – install only one. SQL\*Plus, Tools and ODBC depend on Basic by default;
to use Basic Lite instead:

```bash
brew install instantclient-arm64-basiclite
brew install instantclient-arm64-sqlplus --with-basiclite
```

If in doubt, use **Basic**.

## SQL\*Plus and Tools

`sqlplus`, `expdp`, `impdp`, `exp`, `imp`, `sqlldr` and `wrc` are installed into `$(brew --prefix)/bin` and are on your
`PATH`. They are wrapped in small scripts that set `DYLD_LIBRARY_PATH` to `$(brew --prefix)/lib`, because macOS strips
that variable from child processes (System Integrity Protection).

```bash
sqlplus scott/tiger@//db.example.com:1521/ORCLPDB1
```

## Connecting to a database

The simplest way needs no configuration files at all – the **Easy Connect** syntax:

```
//host:port/service_name          e.g. //db.example.com:1521/ORCLPDB1
```

If you prefer `tnsnames.ora` / `sqlnet.ora`, put them into a directory of your choice and point `TNS_ADMIN` to it, e.g.
in `~/.zprofile`:

```bash
export TNS_ADMIN="$HOME/.oracle/network/admin"
```

Don't put them into the Homebrew prefix – they would be lost on the next upgrade.

## SQL Developer

```bash
brew install --cask sqldeveloper
```

- Installs `/Applications/SQLDeveloper.app`. The app ships with its **own JDK**, no separate Java installation is
  needed.
- SQL Developer uses its built-in JDBC thin driver and does **not** need Instant Client. It can optionally use the OCI
  ("thick") driver: *Preferences → Database → Advanced → Use Oracle Client*, client location `/opt/homebrew/lib`.
- Settings and saved connections live in `~/.sqldeveloper`. They survive upgrades and a normal uninstall;
  `brew uninstall --zap --cask sqldeveloper` removes them as well.
- To migrate settings from another machine, copy `~/.sqldeveloper` before the first start, or export/import the
  connections via the *Connections* panel (right click → *Export Connections…* / *Import Connections…*).

## Updating and uninstalling

```bash
brew update
brew upgrade                      # all outdated formulae and casks, incl. this tap

brew uninstall instantclient-arm64-sdk instantclient-arm64-basic
brew uninstall --cask sqldeveloper
brew untap byn-sebastian-brandner/oracle
```

After an Instant Client upgrade, software built against it keeps working as long as the library version
(`libclntsh.dylib.23.1`) stays the same. After a major upgrade, rebuild it.

## Troubleshooting

**`Library not loaded: @rpath/libclntsh.dylib.23.1`**
The program does not know where to look for the client libraries. For binaries or extensions you built yourself,
add the library path as rpath:

```bash
install_name_tool -add_rpath "$(brew --prefix)/lib" /path/to/your-binary-or-extension
```

**`oci.h: No such file or directory` while building against the client**
The SDK is missing: `brew install instantclient-arm64-sdk`.

**`Cannot install instantclient-arm64-basic because conflicting formulae are installed`**
Basic and Basic Lite can't be installed together – uninstall one of them first.

**`ORA-12154: TNS:could not resolve the connect identifier`**
The alias is not found in `tnsnames.ora`. Check `TNS_ADMIN`, or use Easy Connect (`//host:port/service`) instead.

**macOS blocks SQL Developer on first start**
Open it once via right click → *Open*, or remove the quarantine flag:
`xattr -dr com.apple.quarantine /Applications/SQLDeveloper.app`.

## Maintaining this tap

### New Instant Client release

All formulae share the same version. Oracle's download URLs follow this pattern (version `23.26.2.0.0` → folder
`2326200`):

```
https://download.oracle.com/otn_software/mac/instantclient/<version without dots>/instantclient-<package>-macos.arm64-<version>.dmg
```

1. Look up the new version on the [Instant Client download page][Instant Client Downloads].
2. Download all packages and compute the checksums:

   ```bash
   V=23.26.2.0.0
   for p in basic basiclite odbc sdk sqlplus tools; do
     f="instantclient-$p-macos.arm64-$V.dmg"
     curl -fsSLO "https://download.oracle.com/otn_software/mac/instantclient/${V//./}/$f"
     shasum -a 256 "$f"
   done
   ```

3. Update `url` and `sha256` in all six files under `Formula/`.
4. Mount the DMGs and check that the file names used in the `install` blocks still exist (Oracle sometimes adds a `-1`
   suffix to file names or changes the set of binaries).
5. Commit and test locally before pushing:

   ```bash
   brew untap byn-sebastian-brandner/oracle
   brew tap byn-sebastian-brandner/oracle "$PWD"     # taps the committed state of the local clone
   brew reinstall instantclient-arm64-basic instantclient-arm64-sdk
   brew test instantclient-arm64-sdk
   ```

### New SQL Developer release

Update `version` and `sha256` in `Casks/sqldeveloper.rb` – the URL is derived from the version. The download link is on
the [SQL Developer download page][SQL Developer Downloads].

```bash
shasum -a 256 sqldeveloper-<version>-macos-aarch64.app.zip
```

## License

The formulae and casks in this repository are licensed under the [MIT License](LICENSE). This tap is based on
[InstantClientTap/homebrew-instantclient][upstream].

Oracle Instant Client and Oracle SQL Developer are proprietary software by Oracle and are subject to Oracle's license
terms, which you accept by installing them. This project is not affiliated with or endorsed by Oracle.


[Homebrew]: https://brew.sh
[Oracle Instant Client]: https://www.oracle.com/database/technologies/instant-client.html
[Oracle SQL Developer]: https://www.oracle.com/database/sqldeveloper/
[Instant Client Downloads]: https://www.oracle.com/database/technologies/instant-client/macos-arm64-downloads.html
[SQL Developer Downloads]: https://www.oracle.com/database/sqldeveloper/technologies/download/
[upstream]: https://github.com/InstantClientTap/homebrew-instantclient
