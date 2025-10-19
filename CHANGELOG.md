# Changelog

## [Unreleased]

### Fixed
- Fixed "Unbound variable" error by using `/usr/bin/stat` instead of `stat` for BSD compatibility
- Replaced all relative program calls with absolute paths for compatibility with customized PATH environments:
  - `basename` → `/usr/bin/basename`
  - `pwd` → `/bin/pwd` 
  - `cksum` → `/usr/bin/cksum`
  - `cut` → `/usr/bin/cut`
  - `printf` → `/usr/bin/printf`
  - `rm` → `/bin/rm`
  - `touch` → `/usr/bin/touch`
  - `ls` → `/bin/ls`
  - `whoami` → `/usr/bin/whoami`
  - `date` → `/bin/date`
  - `cat` → `/bin/cat`
  - `tee` → `/usr/bin/tee`
  - `grep` → `/usr/bin/grep`
  - `sandbox-exec` → `/usr/bin/sandbox-exec`
- Script now works reliably regardless of user's PATH configuration