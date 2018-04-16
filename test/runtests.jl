using PMachine
using Base.Test

r1 = Register{ UInt8 }( 1 )

r2 = Register{ UInt8 }()

@test ( typeof( r1 ) == typeof( r2 ) )

@test get( r2 ) == 0x00

set( r2, UInt8( 1 ) )

@test get( r1 ) == get( r2 )

m = Memory{ UInt8, UInt8 }( 10 )

@test getAddr( m ) == 0

@test PMachine.read( m ) == 0

PMachine.write( m, UInt8(99) )

@test PMachine.read( m ) == 99

setAddr( m, UInt8( 2 ) )
PMachine.reset( m )

@test PMachine.read( m ) == 0
@test getAddr( m ) == 0

ma = Machine()

@test codesize( ma ) == 100
@test storesize( ma ) == 100
