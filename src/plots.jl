function plotgene(gene, ecoli)
    ind = findall(occursin.(gene, ecoli.Gene))
    i = 0
    if isempty(ind)
        error("$gene not found")
    elseif length(ind) > 1
        error("multiple matches for $gene:\n$(ecoli.Gene[ind])")
    else
       i = first(ind) 
    end
    plot()
    x = [v for v in ecoli[i, 2:end]]
    labels = replace.(names(ecoli, Not(:Gene)), r"_[123]$" => "")
    dotplot(labels, x, group=labels, leg=:outertopright)
    yl = ylims()
    plot!(ylims=(0, yl[2]))
    
end