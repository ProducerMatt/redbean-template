# Template for Redbean Projects

## Features:

- Build.sh
  - TODO:
    - **INIT**: `build.sh init [-s for sqlite] []`
      - [ ] Fetch Redbean, save as read-only stock build. Also fetch zip and 
            optionally sqlite
      - [ ] *Verify checksums for known versions/generate checksums for new
            ones*
    - **BUILD** (default with no arguments)
      - [ ] force copy stock redbean to writable file. Zip contents of `srv/`
            into zip
      - [ ] *if sqlite.com and `default.sqlite` exist, force copy
            `default.sqlite` to `db.sqlite`*
