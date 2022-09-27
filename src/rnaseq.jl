

function loadecoli(; file="RawCountData_Ecoli.csv", projectdir=getprojectdir(), scale=6e+6)
    filepath = joinpath(projectdir, "data", file)
    ecoli = CSV.read(filepath, DataFrame)
    egenes = ecoli[!, r"Gene"]
    @assert all([egenes[!, 1] == c for c in eachcol(egenes)])
    ecoli_raw = [DataFrame(Gene=egenes[!, 1]) ecoli[!, Not(r"Gene")]]
    ER = Matrix(ecoli_raw[!, 2:end])
    totalreads_ecoli = sum(ER, dims=1)
    # scale = 6e+6
    ecoli = [DataFrame(Gene=egenes[!, 1]) DataFrame(scale*ER./totalreads_ecoli, names(ecoli_raw, Not(:Gene)))]
    estack = stack(ecoli, names(ecoli, Not(:Gene)), variable_name=:Sample, value_name=:Count)
    estack[!, :Condition] = replace.(estack.Sample, r"_[123]$" => "");

    ecoli_raw, ecoli, estack
end