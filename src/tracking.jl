"""
    @track ex

Execute and return the value of `ex` and add table-level metadata having `:note`
style to `parent` of value of `ex`. The key is `"track_"` suffixed by
execution time, as returned by `Dates.now()` (in an unlikely case of duplicate
key already present `"_"` suffix is added to key) and value is string
representation of `ex`.

This macro is meant to allow for lineage of data frame processing pipelines.

# Example

```
julia> using DataFrames

julia> df = DataFrame(a=1:3)
3×1 DataFrame
 Row │ a
     │ Int64
─────┼───────
   1 │     1
   2 │     2
   3 │     3

julia> @track agg = combine(df, :a => sum)
1×1 DataFrame
 Row │ a_sum
     │ Int64
─────┼───────
   1 │     6

julia> print(meta2toml(agg))
style = true

[colmetadata]

[metadata]
"track_2022-11-13T21:18:47.359" = ["agg = combine(df, :a => sum)", "note"]
```

"""
macro track(ex)
    local str = sprint(Base.show_unquoted, esc(ex))
    quote
        local value = $(esc(ex))
        local str = $(sprint(Base.show_unquoted, ex))
        local parent_value = parent(value)
        local key = string("track_", Dates.now())
        # this should never be needed in practice
        while key in DataAPI.metadatakeys(parent_value)
            key *= "_"
        end
        DataAPI.metadata!(parent_value, key, str, style=:note)
        value
    end
end


