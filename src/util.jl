export cond

swap(f) = (x, y) -> f(y, x)

function cond(p::Bool, λt::Function, λf::Function, targs, fargs)
    if p 
        λt(targs...)
    else
        λf(fargs...)
    end
end