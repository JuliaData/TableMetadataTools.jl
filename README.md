# TableMetadataTools.jl
Tools for working with metadata of Tables.jl tables in Julia.

Currently it defines and exports:
* `label`, `label!`, `labels`, and `findlabels` functions for convenient work
  with column label metadata;
* `caption` and `caption!` functions for convenient work with table caption
  metadata;
* `note` and `note!` functions for convenient work with note metadata both on
  table and column level;
* `unit` (re-exported from Unitful.jl), `unit!`, and `units` functions for
  convenient work with column unit metadata;
* `setmetadatastyle!`, `setcolmetadatastyle!`, `setallmetadatastyle!` for group
  setting style for keys matching a passed pattern; usually needed when working
  with metadata that initially has `:default` style set and one wants it to
  have `:note` style (common when reading metadata from storage formats that do
  not support metadata style information);
* `meta2toml` and `toml2meta!` for storing and loading metadata in TOML format;
* `dict2metadata!`, `dict2colmetadata!` for setting table and column level
  metadata stored in a dictionary (e.g. earlier retrieved from some storage
  format or by using `metadata` or `colmetadata` functions).
* the `@track` macro for tracking operations applied to table and
  the `tracklog` function for convenient printing of tracking metadata.

# Installation

This package is still in experimental phase (gathering users' feedback).

To install it write:

```
] add TableMetadataTools.jl
```

(`]` switches you to package manager mode in Julia REPL.)

# Usage

All exported functions have docstrings explaining their behavior.

You can find a demo how the package can be used to work with metadata
in /docs/demo.ipynb Jupyter Notebook.

To run it have your terminal in the /docs folder and do the following steps:
* start Julia with `julia --project`
* to make sure all packages are instantiated correctly run
  `using Pkg; Pkg.instantiate()` (this has to be done only the first time
  you run the demo)
* start Jupyter Notebook by writing `using IJulia; notebook(dir=pwd())`.
* open `demo.ipynb` notebook.

