"""
    setmetadatastyle!([predicate], table; style::Symbol=:note)

Set style for table-level keys in `table` that match `predicate` to `style`.
If `predicate` is omitted then all metadata is updated.

See also: [`setcolmetadatastyle`!](@ref), [`setallmetadatastyle!](@ref)
"""
function setmetadatastyle!(predicate, table; style::Symbol=:note)
    for metakey in DataAPI.metadatakeys(table)
        if predicate(metakey)
            metavalue, metastyle = DataAPI.metadata(table, metakey, style=true)
            if metastyle != style
                DataAPI.metadata!(table, metakey, metavalue, style=style)
            end
        end
    end

    return table
end

setmetadatastyle!(table; style::Symbol=:note) =
    setmetadatastyle!(Returns(true), table, style=style)

"""
    setcolmetadatastyle!([predicate], table; style::Symbol=:note, [col::Symbol])

Set style for column-level keys in `table` that match `predicate` to `style`.
If `predicate` is omitted then all metadata is updated.
If `col` is passed then it must be a column name and only metadata for this
column is updated (if present).

See also: [`setmetadatastyle`!](@ref), [`setallmetadatastyle!](@ref)
"""
function setcolmetadatastyle!(predicate, table; style::Symbol=:note,
                              col::Union{Nothing, Symbol}=nothing)
    for (c, colmetakeys) in DataAPI.colmetadatakeys(table)
        # if col is passed skip all columns except col
        isnothing(col) || c != col || continue
        for colmetakey in colmetakeys
            if predicate(colmetakey)
                colmetavalue, colmetastyle = DataAPI.colmetadata(table, c, colmetakey, style=true)
                if colmetastyle != style
                    DataAPI.colmetadata!(table, c, colmetakey, colmetavalue, style=style)
                end
            end
        end
    end

    return table
end

setcolmetadatastyle!(table; style::Symbol=:note,
                     col::Union{Nothing, Symbol}=nothing) =
    setcolmetadatastyle!(Returns(true), table, style=style, col=col)

"""
    setallmetadatastyle!([predicate], table; style::Symbol=:note)

Set style for table-level and column-level keys in `table` that match
`predicate` to `style`.
If `predicate` is omitted then all metadata is updated.

See also: [`setmetadatastyle`!](@ref), [`setcolmetadatastyle!](@ref)
"""
function setallmetadatastyle!(predicate, table; style::Symbol=:note)
    setmetadatastyle!(predicate, table, style=style)
    setcolmetadatastyle!(predicate, table, style=style)
    return table
end

setallmetadatastyle!(table; style::Symbol=:note) =
    setallmetadatastyle!(Returns(true), table, style=style)

