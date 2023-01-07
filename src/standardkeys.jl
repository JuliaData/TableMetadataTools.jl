"""
    label(table, column)

Return string representation of the value of the `"label"` column-level metadata
of column `column` in `table` that must be compatible with Tables.jl table
interface.

If `"label"` column-level metadata for column `column` is missing return
name of column `column` as string.

See also: [`label!`](@ref), [`labels`](@ref)
```
"""
function label(table, column)
    idx = column isa Union{Signed, Unsigned} ? Int(column) : Tables.columnindex(table, column)
    idx == 0 && throw(ArgumentError("column $column not found in table"))
    # use conditional to avoid calling Tables.columnnames if it is not needed
    if "label" in DataAPI.colmetadatakeys(table, column)
        return string(DataAPI.colmetadata(table, column, "label"))
    else
        cols = Tables.columns(table)
        return string(Tables.columnnames(cols)[idx])
    end
end

"""
    labels(table)

Return a vector of column labels of a `table` by calling [`label`](@ref)
on each its column.

See also: [`label`](@ref), [`label!`](@ref)
```
"""
labels(table) =
    [label(table, column) for column in Tables.columnnames(Tables.columns(table))]

"""
    findlabels(predicate, table)

Return a vector of column_name => column_label pairs containing
all values for which `predicate(label(table, column_name))` returns `true`.
This is intended for a quick lookup of column names whose label meets some
criteria defined by `predicate`.

See also: [`label`](@ref), [`label!`](@ref), [`labels`](@ref)
"""
findlabels(predicate, table) = 
    [column => label(table, column) for column in Tables.columnnames(Tables.columns(table))
     if predicate(label(table, column))]

"""
    label!(table, column, label)

Store string representation of `label` as value of `"label"` key with
`:note`-style as column-level metadata for column `column` in
`table` that must be compatible with Tables.jl table interface.

See also: [`label`](@ref), [`labels`](@ref)
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
    if "caption" in DataAPI.metadatakeys(table)
        return string(DataAPI.metadata(table, "caption"))
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
    if append && "note" in DataAPI.metadatakeys(table)
        DataAPI.metadata!(table, "note",
                          string(TableMetadataTools.note(table), "\n", note), style=:note)
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
    if append && "note" in DataAPI.colmetadatakeys(table, column)
        DataAPI.colmetadata!(table, column, "note",
                             string(TableMetadataTools.note(table, column), "\n", note), style=:note)
    else
        DataAPI.colmetadata!(table, column, "note", string(note), style=:note)
    end

"""
    unit(table, column)

Return representation of the value of the `"unit"` column-level metadata
of column `column` in `table` that must be compatible with Tables.jl table
interface.

If `"unit"` column-level metadata for column `column` is missing and element
type of the column is `Units.Quantity` or `Dates.FixedPeriod` return unit of
this type. If element type is `Number` return `Unitful.NoUnits`. Union with
`Missing` is allowed in the above cases. For all other cases return `missing`.

Warning! The proposed definition of `unit` is type piracy, but it is made
for user convenience. It works under the assumption that other methods for
`unit` (defined in other packages) always take one positional argument.
If this assumption would not hold in the future the definition of `unit` in
this package might change.

See also: [`unit!`](@ref), [`units`](@ref)
```
"""
function Unitful.unit(table, column)
    idx = column isa Union{Signed, Unsigned} ? Int(column) : Tables.columnindex(table, column)
    idx == 0 && throw(ArgumentError("column $column not found in table"))
    # use conditional to avoid calling Tables.columnnames if it is not needed
    if "unit" in DataAPI.colmetadatakeys(table, column)
        return DataAPI.colmetadata(table, column, "unit")
    else
        et = eltype(Tables.getcolumn(Tables.columns(table), column)) 
        et === Missing && return missing
        et <: Union{Unitful.Quantity, Missing} && return unit(et)
        et <: Union{Dates.FixedPeriod, Missing} && return unit(et)
        et <: Union{Unitful.Number, Missing} && return unit(et)
    end
    return missing
end

"""
    units(table)

Return a vector of column units of a `table` by calling [`unit`](@ref)
on each its column.

See also: [`unit!`](@ref), [`labels`](@ref)
```
"""
units(table) =
    [unit(table, column) for column in Tables.columnnames(Tables.columns(table))]

"""
    unit!(table, column, unit)

Store representation of `unit` as value of `"unit"` key with
`:note`-style as column-level metadata for column `column` in
`table` that must be compatible with Tables.jl table interface.
Any value is accepted for user convenience, however `Unitful.Units`
unit is recommended.

Note that if element type of column `column` is `Unitful.Quantity` or
`Dates.FixedPeriod` then setting unit is not needed (but can be done to
override the default unit).

See also: [`unit`](@ref), [`units`](@ref)
"""
unit!(table, column, unit) =
    DataAPI.colmetadata!(table, column, "unit", unit, style=:note)

