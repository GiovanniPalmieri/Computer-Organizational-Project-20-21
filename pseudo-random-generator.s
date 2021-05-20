#pseudo random generator
.data 
initialSeed: .half 60
lfsr:        .half 00

space:        .string " "


.text    


firstTime:
    #test
    li s1,10
    li s0,0
    
    la t0,initialSeed
    la t1,lfsr
    lh t0,(0)t0
    sh t0,(0)t1

getPseudoRandom:
    la t0,lfsr
    lh t0,(0)t0
    beq t0,zero,firstTime #lfsr prende initialSeed per la prima volta
    
    srli t1,t0,2 #t1 = lfsr >> 2
    srli t2,t0,3 #t2 = lfsr >> 3
    srli t3,t0,5 #t3 = lfsr >> 5
    
    xor t4,t0,t1
    xor t4,t4,t2
    xor t4,t4,t3 #t4 = newbit
    
    slli t4,t4,15
    srli t0,t0,1
    
    or t0,t0,t4 #t0 = new lfsr
    
    li t1,65535
    and t0,t0,t1 #remove excess bits
    
    la t1,lfsr
    sh t0,(0)t1
    
    #test
    
    li a7,1
    add a0,zero,t0
    ecall
    
    li a7,4
    la a0,space
    ecall
    
    addi s0,s0,1

    bne s0,s1,getPseudoRandom
    
    
    
    