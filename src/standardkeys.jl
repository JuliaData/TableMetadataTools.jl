"""
    label(table, column)

Return string representation of the value of the `"label"` column-level metadata
of column `column` in `table` that must be compatible with Tables.jl table
interface.

If `"label"` column-level metadata for column `column` is missing return
name of column `column` as string.

See also: [`label!`](@ref)
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

See also: [`label`](@ref)
"""
label!(table, column, label) =
    DataAPI.colmetadata!(table, column, "label", string(label), style=:note)

"""
    caption(table)

Return string representation of the value of the `"caption"` table-level
metadata in `table` that must be compatible with Tables.jl table interface.

If `"caption"` table-level metadata is missing return "".

See also: [`caption!`](@ref)
```
"""
caption(table) =
    if "label" in DataAPI.colmetadatakeys(table, column)
        return string(DataAPI.colmetadata(table, column, "caption"))
    else
        return ""
    end

"""
    caption!(table, caption)

Store string representation of `caption` as value of `"caption"` key with
`:note`-style as table-level metadata in `table` that must be compatible with
Tables.jl table interface.

See also: [`label`](@ref)
"""
caption!(table, caption) =
    DataAPI.metadata!(table, "caption", string(caption), style=:note)

"""
    note(table)

Return string representation of the value of the `"note"` table-level
metadata in `table` that must be compatible with Tables.jl table interface.

If `"note"` table-level metadata is missing return "".

See also: [`note!`](@ref)
```
"""
note(table) =
    if "note" in DataAPI.metadatakeys(table)
        return string(DataAPI.metadata(table, "note"))
    else
        return ""
    end

"""
    note(table, column)

Return string representation of the value of the `"note"` column-level metadata
for column `column` in `table` that must be compatible with Tables.jl table
interface.

If `"note"` column-level metadata for column `column` is missing return "".

See also: [`note!`](@ref)
```
"""
function note(table, column)
    idx = column isa Union{Signed, Unsigned} ? Int(column) : Tables.columnindex(table, column)
    idx == 0 && throw(ArgumentError("column $col not found in table"))
    if "note" in DataAPI.colmetadatakeys(table, column)
        return string(DataAPI.colmetadata(table, column, "note"))
    else
        return ""
    end
end

"""
    note!(table, note; append::Bool=false)

Store string representation of `note` as value of `"note"` key with
`:note`-style as table-level metadata in `table` that must be compatible with
Tables.jl table interface.

If `append=true` then instead of replacing existing `"note"` metadata append
the passed `note` string to the previously present metadata after adding a
newline.

See also: [`note`](@ref)
"""
note!(table, note; append::Bool=false) =
    if append && "note" in metadatakeys(table)
        DataAPI.metadata!(table, column, "note",
                          string(note(table, column), "\n", note), style=:note)
    else
        DataAPI.metadata!(table, "note", string(note), style=:note)
    end

"""
    note!(table, column note; append::Bool=false)

Store string representation of `note` as value of `"note"` key with
`:note`-style as column-level metadata for column `column` in `table` that must
be compatible with Tables.jl table interface.

If `append=true` then instead of replacing existing `"note"` metadata append
the passed `note` string to the previously present metadata after adding a
newline.

See also: [`note`](@ref)
"""
note!(table, column, note; append::Bool=false) =
    if append && "note" in colmetadatakeys(table, column)
        DataAPI.colmetadata!(table, column, "note",
                             string(note(table, column), "\n", label), style=:note)
    else
        DataAPI.colmetadata!(table, column, "note", string(label), style=:note)
    end

