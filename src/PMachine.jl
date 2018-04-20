module PMachine

export Machine, exe, load

# N steht fUr "numerischer" Typ,
# also integer, real oder Adresse, T fur beliebigen einfachen Typ, also fur numerische,
# logische, Zeichen- und Aufzahlungstypen und fur Adressen, i fiir integer, r
# fUr real, b fUr boolean, a fur Adresse

# R = Float64
# B = Bool
# A = Int64
# I = Int64
#
# N = Union{ I, R, A }
# T = Union{ N, B }
#
# C = Union{ Symbol, T }
#
# mutable struct Machine
#     SP      :: A
#     store   :: Vector{ T }
#     PC      :: A
#     code    :: Vector
# end
# Machine( code::Vector = [] ) = Machine( 0, zeros( 100 ), 0, code )
#
# function reset( m::Machine )
#     m.code = []
#     m.PC = 0
# end
#
# function load( m::Machine, c::Vector )
#     reset( m )
#     m.code = c;
# end
#
# function next_code( m::Machine )
#     m.PC += 1
#     m.code[ m.PC ]
# end
#
# function exe_type_symbol_num( m::Machine )
#     t = next_code( m )
#     if typeof( t ) != Symbol
#         throw( "No type symbol after :add, $(t)" )
#     end
#     if t == :i
#         ty = I
#     elseif t == :r
#         ty = R
#     elseif t == :a
#         ty = A
#     else
#         throw( "Unknown numeric type symbol, $( t )" )
#     end
#     ty
# end
#
# function exe_add( m::Machine )
#     ty =  exe_type_symbol_num( m )
#     left  = m.store[ m.SP - 1 ]
#     right = m.store[ m.SP ]
#     if typeof( left ) != ty
#         throw( "Wrong type on SP - 1  for :add, $( left )")
#     end
#     if typeof( right ) != ty
#         throw( "Wrong type on SP  for :add, $( right )")
#     end
#     println( "ADD")
#     m.store[ m.SP - 1 ] = left + right
#     m.SP -= 1
# end
#
# function exe_type_symbol( m::Machine )
#     t = next_code( m )
#     if typeof( t ) != Symbol
#         throw( "No type symbol after :add, $(t)" )
#     end
#     if t == :i
#         ty = I
#     elseif t == :r
#         ty = R
#     elseif t == :a
#         ty = A
#     elseif t == :b
#         ty = B
#     else
#         throw( "Unknown type symbol, $( t )" )
#     end
#     ty
# end
#
#
# function exe_ldc( m::Machine )
#     ty =  exe_type_symbol( m )
#     imm = next_code( m )
#     if typeof( imm ) != ty
#         throw( "Wrong type for :ldc, $( imm )")
#     end
#     m.SP += 1
#     m.store[ m.SP ] = imm
# end
#
#
#
# function exe( m::Machine )
#     run = true
#     while run
#         s = next_code( m )
#         println( s )
#         if s == :nop
#             println( "NOP!" )
#         elseif s == :add
#             exe_add( m )
#         elseif s == :ldc
#             exe_ldc( m )
#         elseif s == :halt
#             println( "SP: $( m.SP ), PC: $( m.PC )" )
#             println( "Store: " )
#             show( m.store )
#             run = false
#         end
#         # println( typeof( s ) )
#     end
# end
#
# function exe( m::Machine, c::Vector )
#     load( m, c )
#     exe( m )
# end


export Register, get, set, reset
import Base.get

mutable struct Register{ Val <: Integer } <: Integer
    value  :: Val
end
Register{T}()           where T = Register{T}( 0 )
Register( val :: T )    where T = Register{T}( val )

get( r :: Register{T} )         where T = r.value
set( r :: Register{T}, v :: T ) where T = r.value = v

reset( r :: Register{T} ) where T = set( r, T( 0 ) )

export Memory, getAddr, setAddr, read, write, reset, size

struct Memory{ Val, Add <: Integer }
    values  :: Vector{ Val }
    addr    :: Register{ Add }
end
Memory{ V, A }( size :: Integer ) where A where V = Memory{ V, A }( zeros( V, size ), Register{ A }() )
# Memory{ V, A }()                  where A where V = Memory{ V, A }( zeros( V, size ), Register{ A }() )

getAddr( m :: Memory{ V, A } )          where A where V = get( m.addr )
setAddr( m :: Memory{ V, A }, a :: A )  where A where V = set( m.addr, a )

read(  m :: Memory{ V, A } )                where A where V = m.values[ get( m.addr ) + 1 ]
write( m :: Memory{ V, A }, value :: V )    where A where V = m.values[ get( m.addr ) + 1 ] = value

size( m :: Memory{ V, A } ) where A where V = length( m.values )

function reset(  m :: Memory{ V, A } ) where A where V
    reset( m.addr )
    fill!( m.values, V( 0 ) )
    m
end

export Machine, codesize, storesize

struct Machine{ Word <: Integer }
    PC      :: Register{ Word }
    SP      :: Register{ Word }

    code    :: Memory{ Word, Word }
    store   :: Memory{ Word, Word }
end

function Machine{ W }( codesize, storesize :: Integer ) where W
    Machine{ W }(
        Register{ W }(),
        Register{ W }(),
        Memory{ W, W }( codesize ),
        Memory{ W, W }( storesize )
    )
end
Machine( codesize, storesize :: Integer ) = Machine{ Int }( codesize, storesize :: Integer )
Machine( size ) = Machine( size, size )
Machine() = Machine( 100 )

# function reset( m :: Machine{ W } ) where W
#     reset( m.PC )
#     reset( m.SP )
#     reset( m.code )
#     reset( m.store )
# end

codesize(  m :: Machine{ W } ) where W = size( m.code )
storesize( m :: Machine{ W } ) where W = size( m.store )

function load( m::Machine{ W }, c::Vector{ W }, start::W = 0 ) where W
    reset( m )
    m.code.values[ 1:end ] = c[ 1:end ];
end

# function next_code( m::Machine )
#     m.PC += 1
#     m.code[ m.PC ]
# end

end

getAddr( m :: Memory{ V, A } )          where A where V = get( m.addr )
setAddr( m :: Memory{ V, A }, a :: A )  where A where V = set( m.addr, a )

read(  m :: Memory{ V, A } )                where A where V = m.values[ getAddr( m ) + 1 ]
write( m :: Memory{ V, A }, value :: V )    where A where V = m.values[ getAddr( m ) + 1 ] = value

end
