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
    setcolmetadatastyle!([predicate], table; style::Symbol=:note)

Set style for column-level keys in `table` that match `predicate` to `style`.
If `predicate` is omitted then all metadata is updated.

See also: [`setmetadatastyle`!](@ref), [`setallmetadatastyle!](@ref)
"""
function setcolmetadatastyle!(predicate, table; style::Symbol=:note)
    for (col, colmetakeys) in DataAPI.colmetadatakeys(table)
        for colmetakey in colmetakeys
            colmetavalue, colmetastyle = DataAPI.colmetadata(table, col, colmetakey, style=true)
            if colmetastyle != style
                DataAPI.colmetadata!(table, col, colmetakey, colmetavalue, style=style)
            end
        end
    end

    return table
end

setcolmetadatastyle!(table; style::Symbol=:note) =
    setcolmetadatastyle!(Returns(true), table, style=style)

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

