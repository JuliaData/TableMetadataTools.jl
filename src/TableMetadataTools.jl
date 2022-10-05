module TableMetadataTools

using DataAPI
using Tables

export label, label!

"""
    label(table, column)

Return string representation of the value of the `"label"` column-level metadata
of column `column` in `table` that must be compatible with Tables.jl table
interface.

If `"label"` column-level metadata for column `column` is missing return
name of column `column` as string.

# Examples

```
using TableMetadataTools
using DataFrames
using Plots
df = DataFrame(ctry=["Poland", "Canada"], gdp=[41685, 57812])
label!(df, :ctry, "Country")
label!(df, :gdp, "GDP per capita (USD PPP, 2022)")
show(df, header=label.(Ref(df), 1:nrow(df)))
bar(df.ctry, df.gdp, xlabel=label(df, :ctry), ylabel=label(df, :gdp), legend=false)
```
"""
function label(table, column)
    idx = column isa Union{Signed, Unsigned} ? Int(column) : Tables.columnindex(table, column)
    idx == 0 && throw(ArgumentError("column $col not found in table"))
    # use conditional to avoid calling Tables.columnnames if it is not needed
    if "label" in DataAPI.colmetadatakeys(table, column)
        return string(DataAPI.colmetadata(table, column, "label"))
    else
        cols = Tables.columns(table)
        return string(Tables.columnnames(cols)[idx])
    end
end

"""
    label!(table, column, label)

Store string representation of `label` as value of `"label"` key with
`:note`-style as column-level metadata for column `column` in
`table` that must be compatible with Tables.jl table interface.

# Examples

```
using TableMetadataTools
using DataFrames
using Plots
df = DataFrame(ctry=["Poland", "Canada"], gdp=[41685, 57812])
label!(df, :ctry, "Country")
label!(df, :gdp, "GDP per capita (USD PPP, 2022)")
show(df, header=label.(Ref(df), 1:nrow(df)))
bar(df.ctry, df.gdp, xlabel=label(df, :ctry), ylabel=label(df, :gdp), legend=false)
```
"""
label!(table, column, label) =
    DataAPI.colmetadata!(table, column, "label", string(label), style=:note)

end # module TableMetadataTools
