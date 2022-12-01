swap(f) = (x, y) -> f(y, x)

function cond(p::Bool, λt::Function, λf::Function, targs, fargs)
    if p 
        λt(targs...)
    else
        λf(fargs...)
    end
end

function eachrow_eager(m)
    collect(eachrow(m))
end

function mapg(f::Function, globals, xs...)
    f′(x...) = f(globals..., x...)
    map(f′, xs...)
end