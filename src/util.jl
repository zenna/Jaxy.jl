export cond

swap(f) = (x, y) -> f(y, x)

function cond(p, λt, λf, x...)
    if p 
        λt(x...)
    else
        λf(x...)
    end
end

# function cond(p, λt, λf)