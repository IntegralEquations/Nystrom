function source_gen(iop::IntegralOperator,kfactor=5)
    nquad  = mapreduce(x->length(x),max,getelements(iop.Y))
    nbasis = 3*nquad
    # construct source basis
    return source_gen(iop,nbasis,kfactor=kfactor)
end

function source_gen(iop,nsources;kfactor)
    N      = ambient_dim(iop)
    Y      = iop.Y
    pts    = getnodes(Y)
    # create a bounding box
    pt_min = minimum(pts)
    pt_max = maximum(pts)
    c      = (pt_min+pt_max) ./ 2
    d      = norm(pt_min-pt_max,2)
    if N===2
        xs     = circle_sources(nsources=nsources,center=c,radius=kfactor*d/2)
    elseif N===3
        xs     = sphere_sources_lebedev(nsources=nsources,center=c,radius=kfactor*d/2)
    else
        error("dimension must be 2 or 3. Got $N")
    end
    return xs
end

function circle_sources(;nsources, radius, center)
    dtheta = 2π / nsources
    theta = dtheta.*collect(0:1:nsources-1)
    Xs = Point{2,Float64}[]
    for th in theta
        x = radius*cos(th) + center[1]
        y = radius*sin(th) + center[2]
        pt = Point(x,y)
        push!(Xs, pt)
    end
    return Xs
end

function circle_random_sources(;nsources, radius, center)
    theta = 2π.*rand(nsources)
    Xs = Point{2,Float64}[]
    for th in theta
        x = radius*cos(th) + center[1]
        y = radius*sin(th) + center[2]
        pt = Point(x,y)
        push!(Xs, pt)
    end
    return Xs
end

function sphere_sources_random(;nsources, radius, center)
    Xs = Point{3,Float64}[]
    for n in 1:nsources
            θ,φ = rand()*2π, rand()*π
            x = center[1] + radius*sin(φ)*cos(θ)
            y = center[2] + radius*sin(φ)*sin(θ)
            z = center[3] + radius*cos(φ)
            pt = Point(x,y,z)
            push!(Xs, pt)
    end
    return Xs
end

function sphere_sources_uniform(;nsources, radius, center)
    Xs = Point{3,Float64}[]
    n  = ceil(sqrt(nsources)) # number of sources per direction (same for θ and φ)
    for i=1:n
        φ = π*(i-1/2)/n
        for j = 1:n
            θ = 2π*(j - 1/2)/n
            x = center[1] + radius*sin(φ)*cos(θ)
            y = center[2] + radius*sin(φ)*sin(θ)
            z = center[3] + radius*cos(φ)
            pt = Point(x,y,z)
            push!(Xs, pt)
        end
    end
    return Xs
end

function sphere_sources_lebedev(;nsources, radius=10, center=Point(0.,0.,0.))
    lpts = lebedev_points(nsources)
    Xs = Point{3,Float64}[]
    for pt in lpts
        push!(Xs,radius*pt .+ center)
    end
    return Xs
end

function lebedev_points(n)
    pts = Vector{Point{3,Float64}}()
    if n<=6
        push!(pts,sph_pt(0,90))
        push!(pts,sph_pt(180,90))
        push!(pts,sph_pt(90,90))
        push!(pts,sph_pt(-90,90))
        push!(pts,sph_pt(90,0))
        push!(pts,sph_pt(90,180))
        return pts
    elseif n<=14
        push!(pts,lebedev_points(6)...)
        push!(pts,sph_pt(45,   54.735610317245346))
        push!(pts,sph_pt(45,   125.264389682754654))
        push!(pts,sph_pt(-45,  54.735610317245346))
        push!(pts,sph_pt(-45,  125.264389682754654))
        push!(pts,sph_pt(135,  54.735610317245346))
        push!(pts,sph_pt(135,  125.264389682754654))
        push!(pts,sph_pt(-135, 54.735610317245346))
        push!(pts,sph_pt(-135, 125.264389682754654))
        return pts
    elseif n<=26
        push!(pts,sph_pt(0,90))
        push!(pts,sph_pt(180,90))
        push!(pts,sph_pt(90,90))
        push!(pts,sph_pt(-90,90))
        push!(pts,sph_pt(90,0))
        push!(pts,sph_pt(90,180))
        push!(pts,sph_pt(90,45))
        push!(pts,sph_pt(90,135))
        push!(pts,sph_pt(-90,45))
        push!(pts,sph_pt(-90,135))
        push!(pts,sph_pt(0,45))
        push!(pts,sph_pt(0,135))
        push!(pts,sph_pt(180,45))
        push!(pts,sph_pt(180,135))
        push!(pts,sph_pt(45,90))
        push!(pts,sph_pt(-45,90))
        push!(pts,sph_pt(135,90))
        push!(pts,sph_pt(-135,90))
        push!(pts,sph_pt(45,54.735610317245346))
        push!(pts,sph_pt(45,125.264389682754654))
        push!(pts,sph_pt(-45,54.735610317245346))
        push!(pts,sph_pt(-45,125.264389682754654))
        push!(pts,sph_pt(135,54.735610317245346))
        push!(pts,sph_pt(135,125.264389682754654))
        push!(pts,sph_pt(-135,54.735610317245346))
        push!(pts,sph_pt(-135,125.264389682754654))
        return pts
    elseif n<=38
        push!(pts,  sph_pt(0.000000000000000,    90.000000000000000))
        push!(pts,sph_pt( 180.000000000000000,    90.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,    90.000000000000000))
        push!(pts,sph_pt( -90.000000000000000,    90.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,     0.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,   180.000000000000000))
        push!(pts,sph_pt(  45.000000000000000,    54.735610317245346))
        push!(pts,sph_pt(  45.000000000000000,   125.264389682754654))
        push!(pts,sph_pt( -45.000000000000000,    54.735610317245346))
        push!(pts,sph_pt( -45.000000000000000,   125.264389682754654))
        push!(pts,sph_pt( 135.000000000000000,    54.735610317245346))
        push!(pts,sph_pt( 135.000000000000000,   125.264389682754654))
        push!(pts,sph_pt(-135.000000000000000,    54.735610317245346))
        push!(pts,sph_pt(-135.000000000000000,   125.264389682754654))
        push!(pts,sph_pt(  62.632194841377327,    90.000000000000000))
        push!(pts,sph_pt( -62.632194841377327,    90.000000000000000))
        push!(pts,sph_pt( 117.367805158622687,    90.000000000000000))
        push!(pts,sph_pt(-117.367805158622687,    90.000000000000000))
        push!(pts,sph_pt(  27.367805158622673,    90.000000000000000))
        push!(pts,sph_pt( -27.367805158622673,    90.000000000000000))
        push!(pts,sph_pt( 152.632194841377355,    90.000000000000000))
        push!(pts,sph_pt(-152.632194841377355,    90.000000000000000))
        push!(pts,sph_pt(   0.000000000000000,    27.367805158622673))
        push!(pts,sph_pt(   0.000000000000000,   152.632194841377355))
        push!(pts,sph_pt( 180.000000000000000,    27.367805158622673))
        push!(pts,sph_pt( 180.000000000000000,   152.632194841377355))
        push!(pts,sph_pt(   0.000000000000000,    62.632194841377327))
        push!(pts,sph_pt(   0.000000000000000,   117.367805158622687))
        push!(pts,sph_pt( 180.000000000000000,    62.632194841377327))
        push!(pts,sph_pt( 180.000000000000000,   117.367805158622687))
        push!(pts,sph_pt(  90.000000000000000,    27.367805158622673))
        push!(pts,sph_pt(  90.000000000000000,   152.632194841377355))
        push!(pts,sph_pt( -90.000000000000000,    27.367805158622673))
        push!(pts,sph_pt( -90.000000000000000,   152.632194841377355))
        push!(pts,sph_pt(  90.000000000000000,    62.632194841377327))
        push!(pts,sph_pt(  90.000000000000000,   117.367805158622687))
        push!(pts,sph_pt( -90.000000000000000,    62.632194841377327))
        push!(pts,sph_pt( -90.000000000000000,   117.367805158622687))
        return pts
    elseif n<=50
        push!(pts,sph_pt(  0.000000000000000,    90.000000000000000))
        push!(pts,sph_pt( 180.000000000000000,    90.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,    90.000000000000000))
        push!(pts,sph_pt( -90.000000000000000,    90.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,     0.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,   180.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,    45.000000000000000))
        push!(pts,sph_pt(  90.000000000000000,   135.000000000000000))
        push!(pts,sph_pt( -90.000000000000000,    45.000000000000000))
        push!(pts,sph_pt( -90.000000000000000,   135.000000000000000))
        push!(pts,sph_pt(   0.000000000000000,    45.000000000000000))
        push!(pts,sph_pt(   0.000000000000000,   135.000000000000000))
        push!(pts,sph_pt( 180.000000000000000,    45.000000000000000))
        push!(pts,sph_pt( 180.000000000000000,   135.000000000000000))
        push!(pts,sph_pt(  45.000000000000000,    90.000000000000000))
        push!(pts,sph_pt( -45.000000000000000,    90.000000000000000))
        push!(pts,sph_pt( 135.000000000000000,    90.000000000000000))
        push!(pts,sph_pt(-135.000000000000000,    90.000000000000000))
        push!(pts,sph_pt(  45.000000000000000,    54.735610317245346))
        push!(pts,sph_pt(  45.000000000000000,   125.264389682754654))
        push!(pts,sph_pt( -45.000000000000000,    54.735610317245346))
        push!(pts,sph_pt( -45.000000000000000,   125.264389682754654))
        push!(pts,sph_pt( 135.000000000000000,    54.735610317245346))
        push!(pts,sph_pt( 135.000000000000000,   125.264389682754654))
        push!(pts,sph_pt(-135.000000000000000,    54.735610317245346))
        push!(pts,sph_pt(-135.000000000000000,   125.264389682754654))
        push!(pts,sph_pt(  45.000000000000000,    25.239401820678911))
        push!(pts,sph_pt(  45.000000000000000,   154.760598179321079))
        push!(pts,sph_pt( -45.000000000000000,    25.239401820678911))
        push!(pts,sph_pt( -45.000000000000000,   154.760598179321079))
        push!(pts,sph_pt( 135.000000000000000,    25.239401820678911))
        push!(pts,sph_pt( 135.000000000000000,   154.760598179321079))
        push!(pts,sph_pt(-135.000000000000000,    25.239401820678911))
        push!(pts,sph_pt(-135.000000000000000,   154.760598179321079))
        push!(pts,sph_pt(  71.565051177077990,    72.451599386207704))
        push!(pts,sph_pt( -71.565051177077990,    72.451599386207704))
        push!(pts,sph_pt(  71.565051177077990,   107.548400613792296))
        push!(pts,sph_pt( -71.565051177077990,   107.548400613792296))
        push!(pts,sph_pt( 108.434948822922010,    72.451599386207704))
        push!(pts,sph_pt(-108.434948822922010,    72.451599386207704))
        push!(pts,sph_pt( 108.434948822922010,   107.548400613792296))
        push!(pts,sph_pt(-108.434948822922010,   107.548400613792296))
        push!(pts,sph_pt(  18.434948822922017,    72.451599386207704))
        push!(pts,sph_pt( 161.565051177078004,    72.451599386207704))
        push!(pts,sph_pt(  18.434948822922017,   107.548400613792296))
        push!(pts,sph_pt( 161.565051177078004,   107.548400613792296))
        push!(pts,sph_pt( -18.434948822922017,    72.451599386207704))
        push!(pts,sph_pt(-161.565051177078004,    72.451599386207704))
        push!(pts,sph_pt( -18.434948822922017,   107.548400613792296))
        push!(pts,sph_pt(-161.565051177078004,   107.548400613792296))
        return pts
    else
        @warn "Unable to return $n Lebedev points"
        sphere_sources_uniform(nsources=n,radius=1,center=(0,0,0))
    end
end

function sph_pt(theta,phi,r=1, center=[0 0 0])
    theta = theta * pi/180
    phi   = phi   * pi/180
    x = center[1] + r*sin(phi)*cos(theta)
    y = center[2] + r*sin(phi)*sin(theta)
    z = center[3] + r*cos(phi)
    return Point{3}(x,y,z)
end

# FIXME: copied from GeometryTypes.jl because there was a bug creating a polygon
# from the package. Should investigate this whenever I have time.
function Base.in(point, points::Vector{<:Point})
    # (point in boundingbox(poly)) || return false
    c = false
    detq(q1, q2, point) = (q1[1]-point[1])*(q2[2]-point[2])-(q2[1]-point[1])*(q1[2]-point[2])
    for i in 1:length(points)-1
        q1,q2 = points[i],points[i+1]
        if q1 == point
            @warn("point on polygon vertex - returning false")
            return false
        end
        if q2[2] == point[2]
            if q2[1] == point[1]
                @warn("point on polygon vertex - returning false")
                return false
            elseif (q1[2] == point[2]) && ((q2[1] > x) == (q1[1] < point[1]))
                @warn("point on edge - returning false")
                return false
            end
        end
        if (q1[2] < point[2]) != (q2[2] < point[2]) # crossing
            if q1[1] >= point[1]
                if q2[1] > point[1]
                    c = !c
                elseif ((detq(q1,q2,point) > 0) == (q2[2] > q1[2])) # right crossing
                    c = !c
                end
            elseif q2[1] > point[1]
                if ((detq(q1,q2,point) > 0) == (q2[2] > q1[2])) # right crossing
                    c = !c
                end
            end
        end
    end
    return c
end
