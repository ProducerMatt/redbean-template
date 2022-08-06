# Template for Redbean Projects

- `build.sh init`: download Redbean, zip, and sqlite
- `build.sh pack`: put contents of `srv/` into a fresh redbean, overwriting
  previously existing bean.
- `build.sh run`: pack and then execute custom command found at top of file

Stock redbeans are hidden with dots. Stock beans, as well as other executables
that are fetched by script, are in the `.gitignore`. Since they are *Actually
Portable*, you could also comment out this behavior and commit the executables
directly, if you're ok with keeping them in the git store.

## Roadmap

- Build.sh
  - **INIT**: `build.sh init [-s for sqlite?]`
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
