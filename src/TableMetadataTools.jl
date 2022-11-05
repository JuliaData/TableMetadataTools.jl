module TableMetadataTools

using DataAPI
using Dates
using Tables
using TOML

export label, label!
export caption, caption!
export note, note!
export setmetadatastyle!, setcolmetadatastyle!, setallmetadatastyle!
export meta2toml, toml2meta!
export dict2metadata, dict2colmetadata!

include("standardkeys.jl")
include("updatestyle.jl")
include("convenience.jl")

end # module TableMetadataTools

