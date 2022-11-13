# TableMetadataTools.jl
Tools for working with metadata of Tables.jl tables in Julia.

Currently it defines and exports:
* `label`, `label!`, and `labels` functions for convenient work with column
  label metadata;
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
* `dict2metadata!`, `dict2colmetadata!` for setting table and column level
  metadata stored in a dictionary (e.g. earlier retrieved from some storage
  format or by using `metadata` or `colmetadata` functions).

# Example

```
using DataFrames
using TableMetadataTools
using Plots

df = DataFrame(year=2018:2021, 
               gdppc=[15468.48222, 15732.20313, 15742.45373, 17840.92105])
caption!(df, "GDP per capita of Poland");
note!(df, "World Bank national accounts data, \
           and OECD National Accounts data files.");
metadata!(df, "License", "CC BY-4.0")
metadata!(df, "Periodicity", "Annual")
label!(df, :gdppc, "GDP per capita (current USD)");
note!(df, :gdppc, "GDP: gross domestic product");
note!(df, :gdppc, "population taken in midyear", append=true);
caption(df)
label(df, :year)
label(df, :gdppc)
println(note(df))
println(note(df, :year))
println(note(df, :gdppc))
metadata(df, style=true)
setmetadatastyle!(df)
metadata(df, style=true)
toml_meta = meta2toml(df, style=false);
println(toml_meta)
toml2meta!(df, toml_meta)
println(meta2toml(df))
setallmetadatastyle!(df)
println(meta2toml(df))

df2 = copy(df)
println(meta2toml(df2))
emptymetadata!(df2)
emptycolmetadata!(df2)
println(meta2toml(df2))
dict2metadata!(df2, metadata(df))
dict2colmetadata!(df2, colmetadata(df))
println(meta2toml(df2))
dict2metadata!(df2, metadata(df, style=true), style=true)
dict2colmetadata!(df2, colmetadata(df, style=true), style=true)
println(meta2toml(df2))

show(df, header=labels(df), title=caption(df))
plot(df.year, df.gdppc, xlabel=label(df, :year), ylabel=label(df, :gdppc), title=caption(df), legend=false)
```

