# AUR-ELF-Injection-2026.07-Check

Quick detection script for the **July 2026 AUR ELF injection campaign**.

## Background

On July 30, 2026, Saren posted on the Arch Linux AUR-general mailing list reporting that AUR packages contained malicious ELF binaries embedded directly in their source/build trees. The official list of **59 affected packages** (updated August 1, 2026) was published by sakaru on [GitHub](https://gist.github.com/sakaru/b06b9a28f188ac737a3a96b017b610d2). The AUR maintainer Antiz (Robin Candau) handled the cleanup and bans.

**Current status (July 31, 2026):** All infected PKGBUILDs have been cleaned up. Adoption for packages is temporarily disabled while the AUR team works on making the process more robust.

**Risk level:** Low. The `pkgrel` was not bumped in the malicious commits, so AUR helpers would not have triggered automatic updates. Only users who manually installed affected packages in the last 3-4 days are at risk.

**Source:** [AUR-general mailing list thread](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/thread/P4WIRHTFNH2YZWQHGBAKQWX5YOAFIDLY/)

## How this attack differs from the June 2026 campaign

| | June 2026 (atomic-lockfile) | July 2026 (ELF injection) |
|---|---|---|
| **Delivery** | npm/bun `preinstall` hooks in PKGBUILD | Malicious ELF binaries embedded in source trees |
| **Payload** | `deps` credential stealer + eBPF rootkit | Unknown ELF binaries (linter, minifier, hasher, etc.) |
| **Scope** | 1600+ packages | 57 packages |
| **Detection** | Package name matching + deep system scan | Package name matching only |

The malicious binaries use generic names like `linter`, `minifier`, `hasher`, `converter`, `indexer`, `encryptor`, `checker`, `tagger`, `parser`, `preprocessor`, `generator`, `validator`, `assembler`, `packer`, `compressor`, `serializer`, `migrator`, `optimizer`, and `merger` to blend in with legitimate build artifacts.

## Usage

**Option 1: Run directly (one-liner)**

```bash
curl -sSf https://raw.githubusercontent.com/A1RM4X/AUR-ELF-Injection-2026.07-Check/main/check-elf-injection.sh | bash
```

**Option 2: Clone and run**

```bash
git clone https://github.com/A1RM4X/AUR-ELF-Injection-2026.07-Check.git
cd AUR-ELF-Injection-2026.07-Check
bash check-elf-injection.sh
```

## Remediation

If any affected packages are found:

1. **Uninstall** the affected package(s): `pacman -Rns <package>`
2. **Clear your AUR helper cache**: `rm -rf ~/.cache/yay/<package> ~/.cache/paru/<package>`
3. **Reinstall** from the cleaned AUR source
4. **Rotate credentials** if you suspect the binaries were executed

## Exit codes

- `0` — Clean, no affected packages installed
- `1` — Affected package(s) found
