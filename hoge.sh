_SQLITE3_DIR=$(ls /nix/store/ | rg sqlite-$(sqlite3 --version | cut -d ' ' -f 1)$ | head -n 1)
ls "/nix/store/${_SQLITE3_DIR}/lib"
