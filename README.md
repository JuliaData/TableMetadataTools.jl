# TableMetadataTools.jl
Tools for working with metadata of Tables.jl tables in Julia.

Currently it defines and exports:
* `label` and `label!` functions for convenient setting column label metadata;
* `meta2toml` and `toml2meta!` for storing and loading metadata in TOML format;
* `meta2dict` for extracting table-level and column-level metadata to dictionaries;
* `setmetadatastyle!` for group setting style of keys matching a passed pattern
  (usually needed when working with metadata stored in formats that do not
  support metadata style);