"""
    @track ex

Execute and return the value of `ex` and add table-level metadata having `:note`
style to `parent` of value of `ex`. The key is `"track_"` suffixed by
execution time, as returned by `Dates.now()` (in an unlikely case of duplicate
key already present `"_"` suffix is added to key) and value is string
representation of `ex`.

This macro is meant to allow for lineage of data frame processing pipelines.

See also: [`tracklog`]

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

"""
    tracklog(io::IO=stdout, obj)

Print to `io` tracking information of `obj` sorted by time stamp.

See also: [`@track`]

# Example

```
julia> using DataFrames

julia> @track df = DataFrame(col = [4, 1, 3, 2])
4×1 DataFrame
 Row │ col   
     │ Int64 
─────┼───────
   1 │     4
   2 │     1
   3 │     3
   4 │     2

julia> @track sort!(df)
4×1 DataFrame
 Row │ col   
     │ Int64 
─────┼───────
   1 │     1
   2 │     2
   3 │     3
   4 │     4

julia> @track transform!(df, :col => ByRow(log))
4×2 DataFrame
 Row │ col    col_log  
     │ Int64  Float64  
─────┼─────────────────
   1 │     1  0.0
   2 │     2  0.693147
   3 │     3  1.09861
   4 │     4  1.38629

julia> @track transform!(df, :col => ByRow(exp))
4×3 DataFrame
 Row │ col    col_log   col_exp  
     │ Int64  Float64   Float64  
─────┼───────────────────────────
   1 │     1  0.0        2.71828
   2 │     2  0.693147   7.38906
   3 │     3  1.09861   20.0855
   4 │     4  1.38629   54.5982

julia> metadata(df)
Dict{String, String} with 4 entries:
  "track_2022-11-13T22:33:21.952" => "transform!(df, :col => ByRow(log))"
  "track_2022-11-13T22:33:13.295" => "df = DataFrame(col = [4, 1, 3, 2])"
  "track_2022-11-13T22:33:15.797" => "sort!(df)"
  "track_2022-11-13T22:33:25.155" => "transform!(df, :col => ByRow(exp))"

julia> tracklog(df)
df = DataFrame(col = [4, 1, 3, 2])
sort!(df)
transform!(df, :col => ByRow(log))
transform!(df, :col => ByRow(exp))
```
"""
function tracklog(io::IO, obj)
    keys = [key for key in DataAPI.metadatakeys(obj) if startswith(key, "track_")]
    values = [DataAPI.metadata(obj, key) for key in keys]
    stamps = [DateTime(strip(chop(key, head=6, tail=0), '_')) for key in keys]
    foreach(x -> println(io, x), values[sortperm(stamps)])
end

tracklog(obj) = tracklog(stdout, obj)

