function loadecoligenelengths(file="ecoli_U00096.3.gff3", projectdir=getprojectdir())
    filepath = joinpath(projectdir, "data", file)
    ecoligff = CSV.read(filepath, DataFrame, comment="#", header=[:Genome, :Origin, :feature, :start, :stop, :score, :strand, :frame, :description])
    dd = @showprogress map(descriptiondict, ecoligff.description)
    ecoligff.HasLocusTag = haskey.(dd, "locus_tag")
    ecoligff.LocusTag = get.(dd, "locus_tag", "")
    ecoligff = @subset(ecoligff, :HasLocusTag)
    ecoligff.Length = ecoligff.stop .- ecoligff.start .+ 1
    
    
    ecoli_gene_lengths = combine(groupby(ecoligff, :LocusTag), :Length => maximum => :Length)
    ecoli_gene_lengths
end

function descriptiondict(str)
    fields = split.(split(str, ";"), "=")
    Dict(f[1] => f[2] for f in fields)
end