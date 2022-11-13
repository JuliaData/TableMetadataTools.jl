module TableMetadataTools

using DataAPI
using Dates
using Tables
using TOML

export label, label!, labels
export caption, caption!
export note, note!
export setmetadatastyle!, setcolmetadatastyle!, setallmetadatastyle!
export meta2toml, toml2meta!
export dict2metadata!, dict2colmetadata!
export @track

include("standardkeys.jl")
include("updatestyle.jl")
include("convenience.jl")
include("tracking.jl")

end # module TableMetadataTools

