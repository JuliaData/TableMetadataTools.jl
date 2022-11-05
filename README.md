# TableMetadataTools.jl
Tools for working with metadata of Tables.jl tables in Julia.

Currently it defines and exports:
* `label` and `label!` functions for convenient work with column label
  metadata;
* `caption` and `caption!` functions for convenient work with table caption
  metadata;
* `note` and `note!` functions for convenient work with note metadata both on
  table and column level;
* `setmetadatastyle!`, `setcolmetadatastyle!`, `setallmetadatastyle!` for group
  setting style for keys matching a passed pattern; usually needed when working
  with metadata that initially has `:defualt` style set and one wants it to
  have `:note` style (common when reading metadata from storage formats that do
  not support metadata style information);
* `meta2toml` and `toml2meta!` for storing and loading metadata in TOML format;
* `dict2metadata`, `dict2colmetadata!` for setting table and column level
  metadata stored in a dictionary (e.g. earlier retrieved from some storage
  format or by using `metadata` or `colmetadata` functions).

# Example

(will be added after DataAPI.jl 1.13.0 release)

