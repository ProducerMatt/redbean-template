# Template for Redbean Projects

- `build.sh init`: download Redbean, zip, and sqlite
- `build.sh pack`: put contents of `srv/` into a fresh redbean, overwriting
  previously existing bean.
- `build.sh run`: pack and then execute custom comand found at top of file

## Roadmap

- Build.sh
  - **INIT**: `build.sh init [-s for sqlite] []`
    - [x] Fetch Redbean, save as read-only stock build.
    - [x] Also fetch zip & sqlite
    - [ ] make sqlite opt-in
    - [ ] *Verify checksums for known versions/generate checksums for new
          ones*
  - **PACK** (default with no arguments)
    - [x] force copy stock redbean to writable file. Zip contents of `srv/`
          into zip
    - [ ] user-specified actions: if one script named `packer*` exists and is
          executable, run it
    - [ ] *if sqlite.com and `default.sqlite` exist, force copy
          `default.sqlite` to `db.sqlite`*
  - **RUN**
    - [x] pack and then execute command specified in variable
