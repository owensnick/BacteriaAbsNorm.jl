function load_ecoli_spikes(file = "ecoli_spike_conc.tsv", projectdir=getprojectdir())
    filepath = joinpath(projectdir, "data", file)
    spk_ecoli = CSV.read(filepath, DataFrame)
    spk_ecoli.TotalSpiked = spk_ecoli.Final.*25
    spk_ecoli
end

function load_ercc_spikes(file="ERCC92.gtf", projectdir=getprojectdir())
    filepath = joinpath(projectdir,  "data", file)
    CSV.read(filepath, DataFrame,header=[:Gene, :Origin, :Feature, :start, :stop, :strand, :strand, :frame, :description])
end

"""
    ecoli_spike_norm(etack, spk_ecoli, ft=0.1)

    estack - stacked data frame of depth normalised gene expression
    spk_ecoli - spike concentrations
    ft - threshold for building spoke model, those with conc < ft fmol/

"""
function ecoli_spike_norm(estack, spk_ecoli, ft=0.1)

    ecs = innerjoin(@subset(estack[!, Not(:Length)], occursin.(r"spk", :Gene)), spk_ecoli, on=:Gene => :Spike)

    spike_model = lm(@formula(log(TotalSpiked) ~ log(Count) + log(Length) + Condition), @subset(ecs, :Final .> ft))
    println("Spike model R2: ", round(r2(spike_model), digits=4))
    spike_model
end