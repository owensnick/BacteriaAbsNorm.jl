using DataFrames, DataFramesMeta, CSV, ProgressMeter, Statistics
using Plots, StatsPlots, Measures


using Statistics, StatsBase, GLM

include("rnaseq.jl")
include("plots.jl")
include("genemodels.jl")
include("spikes.jl")
function showwide(table)
    c = ENV["COLUMNS"]
    ENV["COLUMNS"] = "10000"
    display(table)
    ENV["COLUMNS"] = c;
    nothing;
end

function showwl(lines=200, nc=10000)
    
    table -> begin
        l = ENV["LINES"]
        c = ENV["COLUMNS"]
        ENV["LINES"] = string(lines)
        ENV["COLUMNS"] = string(nc)
        display(table)
        ENV["LINES"] = l;
        ENV["COLUMNS"] = c;
        nothing;
    end
end

function getprojectdir()
    d = pwd()
    if basename(d) == "notebooks"
        return dirname(d)
    else
        return d
    end
end

function loadall()
    ecoli_raw, ecoli, estack = loadecoli()
    ecoli_gene_lengths = loadecoligenelengths()
    spk_ecoli = load_ecoli_spikes()
    ercc = load_ercc_spikes()

    # display(ecoli_gene_lengths)
    # display(spk_ecoli)
    # display(ercc)
    genelengths = [rename(ecoli_gene_lengths, :LocusTag => :Gene) ; rename(spk_ecoli[!, [:Spike, :Length]], [:Gene, :Length]) ;rename(ercc[!, [:Gene, :stop]], [:Gene, :Length])]
    

    estacklength = innerjoin(estack, genelengths, on=:Gene);

    ecoli_raw, ecoli, spk_ecoli, genelengths, estacklength
end