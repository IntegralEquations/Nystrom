using Nystrom, FastGaussQuadrature, Plots, LinearAlgebra, IterativeSolvers, ParametricSurfaces, LaTeXStrings
using Nystrom: circle_helmholtz_soundsoft, error_exterior_green_identity, Point

function scattering_helmholtz_circle_soundsoft_spectrum(p,h)
    dim = 2
    R = 1
    geo = Circle(radius=R)
    fig = plot(st=:scatter,m=:x,label="",xlabel="Re(λ)",ylabel="Im(λ)",
               framestyle=:box,xtickfontsize=10,ytickfontsize=10)
    k         = π
    pde       = Helmholtz(dim=dim,k=k)
    meshgen!(geo,h)
    markers = (:x,:+,:circle)
    cc = 0
    for p in p
        cc+=1
        Γ = quadgen(geo,p,gausslegendre)
        S,D   = single_double_layer(pde,Γ)
        L = I/2 + D - im*k*S
        evals = eigvals(L)
        plot!(fig,real.(evals),imag.(evals),st=:scatter,m=markers[cc],label="p=$p")
    end
    return fig
end

h      = 0.1
p      = (2,3)
fig    = scattering_helmholtz_circle_soundsoft_spectrum(p,h)
fname = "/home/lfaria/Dropbox/Luiz-Carlos/general_regularization/draft/figures/fig4c.pdf"
savefig(fig,fname)
display(fig)