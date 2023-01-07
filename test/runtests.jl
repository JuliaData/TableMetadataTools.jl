using DataFrames
using TableMetadataTools
using Test
using Unitful

@testset "label, label!, labels" begin
    df = DataFrame(a=1, b=2, c=3)
    @test label!(df, :b, "BBB") == df
    label!(df, 3, 10)
    @test labels(df) == ["a", "BBB", "10"]
    label!(df, "b", "BB")
    @test labels(df) == ["a", "BB", "10"]
    @test label(df, :a) == "a"
    @test label(df, "b") == "BB"
    @test label(df, 3) == "10"
    @test colmetadata(df, :b, "label", style=true) == ("BB", :note)
end

@testset "caption, caption!" begin
    df = DataFrame(a=1, b=2, c=3)
    @test caption(df) == ""
    @test caption!(df, "table") == df
    @test caption(df) == "table"
    @test metadata(df, "caption", style=true) == ("table", :note)
end

@testset "note, note!" begin
    df = DataFrame(a=1, b=2, c=3)
    @test note(df) == ""
    @test note(df, :a) == ""

    note!(df, "one")
    @test note(df) == "one"
    note!(df, "two")
    @test note(df) == "two"
    note!(df, "three", append=true)
    @test note(df) == "two\nthree"
    @test metadata(df, "note", style=true) == ("two\nthree", :note)

    note!(df, :b, "one")
    @test note(df, 2) == "one"
    note!(df, "b", "two")
    @test note(df, "b") == "two"
    note!(df, :b, "three", append=true)
    @test note(df, 2) == "two\nthree"
    @test colmetadata(df, :b, "note", style=true) == ("two\nthree", :note)
end

@testset "unit, unit!, units" begin
    df = DataFrame(a=1, b="2", c=3, d=5u"s")
    @test unit(df, :a) == unit(Int)
    @test ismissing(unit(df, :b))
    @test unit(df, :d) == unit(eltype(df.d))
    @test unit!(df, :b, "BBB") == df
    unit!(df, 3, 10)
    @test units(df) == [unit(Int), "BBB", 10, unit(eltype(df.d))]
    unit!(df, "b", "BB")
    @test units(df) == [unit(Int), "BB", 10, unit(eltype(df.d))]
    @test unit(df, "b") == "BB"
    @test unit(df, 3) == 10
    @test colmetadata(df, :b, "unit", style=true) == ("BB", :note)

    push!(df, [missing, missing, missing, missing], promote=true)
    @test unit(df, :a) == unit(Int)
    @test unit(df, :d) == unit(eltype(df.d))
end

@testset "setmetadatastyle!, setcolmetadatastyle!, setallmetadatastyle!" begin
    df = DataFrame(a=1, b=2, c=3)
    caption!(df, "xxx")
    label!(df, :a, "yyy")
    note!(df, "1")
    note!(df, :b, "2")
    @test metadata(df, "caption", style=true) == ("xxx", :note)
    @test metadata(df, "note", style=true) == ("1", :note)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :note)
    @test colmetadata(df, :b, "note", style=true) == ("2", :note)

    setmetadatastyle!(==("caption"), df, style=:default)
    setcolmetadatastyle!(==("note"), df, style=:default, col=:b)
    @test metadata(df, "caption", style=true) == ("xxx", :default)
    @test metadata(df, "note", style=true) == ("1", :note)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :note)
    @test colmetadata(df, :b, "note", style=true) == ("2", :note)

    setmetadatastyle!(==("caption"), df)
    setcolmetadatastyle!(==("note"), df)
    @test metadata(df, "caption", style=true) == ("xxx", :note)
    @test metadata(df, "note", style=true) == ("1", :note)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :note)
    @test colmetadata(df, :b, "note", style=true) == ("2", :note)

    setmetadatastyle!(df, style=:default)
    setcolmetadatastyle!(df, style=:default)
    @test metadata(df, "caption", style=true) == ("xxx", :default)
    @test metadata(df, "note", style=true) == ("1", :default)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :default)
    @test colmetadata(df, :b, "note", style=true) == ("2", :default)

    setmetadatastyle!(df)
    setcolmetadatastyle!(df)
    @test metadata(df, "caption", style=true) == ("xxx", :note)
    @test metadata(df, "note", style=true) == ("1", :note)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :note)
    @test colmetadata(df, :b, "note", style=true) == ("2", :note)

    setallmetadatastyle!(==("note"), df, style=:default)
    @test metadata(df, "caption", style=true) == ("xxx", :note)
    @test metadata(df, "note", style=true) == ("1", :default)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :note)
    @test colmetadata(df, :b, "note", style=true) == ("2", :default)

    setallmetadatastyle!(df)
    @test metadata(df, "caption", style=true) == ("xxx", :note)
    @test metadata(df, "note", style=true) == ("1", :note)
    @test colmetadata(df, :a, "label", style=true) == ("yyy", :note)
    @test colmetadata(df, :b, "note", style=true) == ("2", :note)
end

@testset "meta2toml, toml2meta!" begin
    df = DataFrame(a=1, b=2, c=3)
    res1 = meta2toml(df)
    @test res1 == "style = true\n\n[colmetadata]\n\n[metadata]\n"
    res2 = meta2toml(df, style=false)
    @test res2 == "style = false\n\n[colmetadata]\n\n[metadata]\n"

    caption!(df, "a")
    label!(df, :b, "B")
    res3 = meta2toml(df)
    @test res3 == "style = true\n\n[colmetadata.b]\nlabel = [\"B\", \"note\"]\n\n[metadata]\ncaption = [\"a\", \"note\"]\n"
    res4 = meta2toml(df, style=false)
    @test res4 == "style = false\n\n[colmetadata.b]\nlabel = \"B\"\n\n[metadata]\ncaption = \"a\"\n"

    @test toml2meta!(df, res1) == df
    @test isempty(metadata(df))
    @test isempty(colmetadata(df))

    caption!(df, "a")
    label!(df, :b, "B")
    toml2meta!(df, res2)
    @test isempty(metadata(df))
    @test isempty(colmetadata(df))

    toml2meta!(df, res3)
    @test metadata(df, style=true) == Dict("caption" => ("a", :note))
    @test colmetadata(df, style=true) == Dict(:b => Dict("label" => ("B", :note)))

    toml2meta!(df, res4)
    @test metadata(df, style=true) == Dict("caption" => ("a", :default))
    @test colmetadata(df, style=true) == Dict(:b => Dict("label" => ("B", :default)))

    emptymetadata!(df)
    emptycolmetadata!(df)
    toml2meta!(df, res4)
    @test metadata(df, style=true) == Dict("caption" => ("a", :default))
    @test colmetadata(df, style=true) == Dict(:b => Dict("label" => ("B", :default)))

    toml2meta!(df, res4)
    @test metadata(df, style=true) == Dict("caption" => ("a", :default))
    @test colmetadata(df, style=true) == Dict(:b => Dict("label" => ("B", :default)))
end

@testset "dict2metadata!, dict2colmetadata!" begin
    df = DataFrame(a=1, b=2, c=3)
    caption!(df, "a")
    label!(df, :b, "B")
    meta1 = metadata(df)
    meta2 = metadata(df, style=true)
    colmeta1 = colmetadata(df)
    colmeta2 = colmetadata(df, style=true)

    df2 = DataFrame(a=1, b=2, c=3)
    dict2metadata!(df2, meta1)
    @test metadata(df2, style=true) == Dict("caption" => ("a", :default))
    dict2metadata!(df2, meta1, defaultstyle=:note)
    @test metadata(df2, style=true) == Dict("caption" => ("a", :note))

    df2 = DataFrame(a=1, b=2, c=3)
    dict2metadata!(df2, meta2, style=true)
    @test metadata(df2, style=true) == Dict("caption" => ("a", :note))

    df2 = DataFrame(a=1, b=2, c=3)
    dict2colmetadata!(df2, colmeta1)
    @test colmetadata(df2, style=true) == Dict(:b => Dict("label" => ("B", :default)))
    dict2colmetadata!(df2, colmeta1, defaultstyle=:note)
    @test colmetadata(df2, style=true) == Dict(:b => Dict("label" => ("B", :note)))

    df2 = DataFrame(a=1, b=2, c=3)
    dict2colmetadata!(df2, colmeta2, style=true)
    @test colmetadata(df2, style=true) == Dict(:b => Dict("label" => ("B", :note)))
end

@testset "@track, tracklog" begin
    df = DataFrame(a=1:3)
    @track agg = combine(df, :a => sum)
    meta = metadata(agg, style=true)
    k = only(keys(meta))
    @test startswith(k, "track")
    meta[k] == ("agg = combine(df, :a => sum)", :note)
    @test ncol(@track select!(agg)) == 0

    io = IOBuffer()
    tracklog(io, agg)
    str = String(take!(io))
    @test str == "agg = combine(df, :a => sum)\nselect!(agg)\n"
end

