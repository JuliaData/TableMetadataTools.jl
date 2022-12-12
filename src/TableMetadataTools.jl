module TableMetadataTools

using DataAPI
using Dates
using Tables
using TOML
using Unitful

export label, label!, labels, findlabels
export caption, caption!
export note, note!
export unit, units, unit!
export setmetadatastyle!, setcolmetadatastyle!, setallmetadatastyle!
export meta2toml, toml2meta!
export dict2metadata!, dict2colmetadata!
export @track, tracklog

include("standardkeys.jl")
include("updatestyle.jl")
include("convenience.jl")
include("tracking.jl")

end # module TableMetadataTools

