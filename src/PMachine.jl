module PMachine

export Machine, exe, load

# N steht fUr "numerischer" Typ,
# also integer, real oder Adresse, T fur beliebigen einfachen Typ, also fur numerische,
# logische, Zeichen- und Aufzahlungstypen und fur Adressen, i fiir integer, r
# fUr real, b fUr boolean, a fur Adresse

R = Float64
B = Bool
A = Int64
I = Int64

N = Union{ I, R, A }
T = Union{ N, B }

C = Union{ Symbol, T }

mutable struct Machine
    SP      :: A
    store   :: Vector{ T }
    PC      :: A
    code    :: Vector
end
Machine( code::Vector = [] ) = Machine( 0, zeros( 100 ), 0, code )

function reset( m::Machine )
    m.code = []
    m.PC = 0
end

function load( m::Machine, c::Vector )
    reset( m )
    m.code = c;
end

function next_code( m::Machine )
    m.PC += 1
    m.code[ m.PC ]
end

function exe_type_symbol_num( m::Machine )
    t = next_code( m )
    if typeof( t ) != Symbol
        throw( "No type symbol after :add, $(t)" )
    end
    if t == :i
        ty = I
    elseif t == :r
        ty = R
    elseif t == :a
        ty = A
    else
        throw( "Unknown numeric type symbol, $( t )" )
    end
    ty
end

function exe_add( m::Machine )
    ty =  exe_type_symbol_num( m )
    left  = m.store[ m.SP - 1 ]
    right = m.store[ m.SP ]
    if typeof( left ) != ty
        throw( "Wrong type on SP - 1  for :add, $( left )")
    end
    if typeof( right ) != ty
        throw( "Wrong type on SP  for :add, $( right )")
    end
    println( "ADD")
    m.store[ m.SP - 1 ] = left + right
    m.SP -= 1
end

function exe_type_symbol( m::Machine )
    t = next_code( m )
    if typeof( t ) != Symbol
        throw( "No type symbol after :add, $(t)" )
    end
    if t == :i
        ty = I
    elseif t == :r
        ty = R
    elseif t == :a
        ty = A
    elseif t == :b
        ty = B
    else
        throw( "Unknown type symbol, $( t )" )
    end
    ty
end


function exe_ldc( m::Machine )
    ty =  exe_type_symbol( m )
    imm = next_code( m )
    if typeof( imm ) != ty
        throw( "Wrong type for :ldc, $( imm )")
    end
    m.SP += 1
    m.store[ m.SP ] = imm
end



function exe( m::Machine )
    run = true
    while run
        s = next_code( m )
        println( s )
        if s == :nop
            println( "NOP!" )
        elseif s == :add
            exe_add( m )
        elseif s == :ldc
            exe_ldc( m )
        elseif s == :halt
            println( "SP: $( m.SP ), PC: $( m.PC )" )
            println( "Store: " )
            show( m.store )
            run = false
        end
        # println( typeof( s ) )
    end
end

function exe( m::Machine, c::Vector )
    load( m, c )
    exe( m )
end


export Memory, get, set

struct Memory{ Val, Add <: Integer }
    values   :: Vector{ Val }
end
Memory{ Val, Add }( size :: Add ) where Add where Val = Memory{ Val, Add }( zeros( Val, size ) )
# Memory{ Val, Add }() = Memory{ Val, Add }( [ 0, 0 ] )

# get( m :: Memory{ Val, Add }, addr :: Add )             = m.values[ addr ]
# set( m :: Memory{ Val, Add }, addr :: Add, val :: Val ) = m.values[ addr ] = val


export Register

struct Register{ Val <: Integer } <: Integer
    value  :: Val
end
Register{T}() where T = Register{T}( 0 )
Register( val :: T ) where T = Register{T}( val )


end
