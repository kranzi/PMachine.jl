import PMachine
using Base.Test

r1 = PMachine.Register{ UInt8 }( 1 )

r2 = PMachine.Register{ UInt8 }()

@test ( typeof( r1 ) == typeof( r2 ) )

@test get( r2 ) == 0x00

PMachine.set( r2, UInt8( 1 ) )

@test get( r1 ) == get( r2 )

m = PMachine.Memory{ UInt8, UInt8 }( 10 )

@test PMachine.getAddr( m ) == 0

@test PMachine.read( m ) == 0

PMachine.write( m, UInt8(99) )

@test PMachine.read( m ) == 99

PMachine.setAddr( m, UInt8( 2 ) )
PMachine.reset( m )

@test PMachine.read( m ) == 0
@test PMachine.getAddr( m ) == 0

ma = PMachine.Machine()

@test PMachine.codesize( ma ) == 100
@test PMachine.storesize( ma ) == 100
