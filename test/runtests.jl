using PMachine
using Base.Test

# write your own tests here
# @test 1 == 2
# m = Machine()
# # load( m, [ :ldc, :i, 1, :ldc, :i, 1, :add, :i] )
# # exe( m )
# m
# exe( m, [ :ldc, :i, 1, :halt ] )
# exe( m, [ :ldc, :i, 1, :halt ] )
# exe( m, [ :add, :i, :halt ] )
#
# # exe( m, [ :ldc, :i, 1, :ldc, :i, 2, :add, :i, :halt ] )
# m = Memory{ Int8, Int8 }( Int8(10) )
#
# zeros( Int8, 10 )
#
# m = Memory{ Int8, Int8 }
# m.values
#
# m = Memory{ Int8, Int8 }( zeros( Int8, 10 ) )
# m.values

Register{ UInt8 }( 1 )

r = Register{ UInt8 }()

get( r )

set( r, UInt8(1) )

get( r )

m = Memory{ UInt8, UInt8 }( 10 )

getAddr( m )

read( m )
