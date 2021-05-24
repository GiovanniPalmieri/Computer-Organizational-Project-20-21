#pseudo random generator
.data 
initialSeed: .half 60
lfsr:        .half 00



.text    


main:
    #s0 => primo elemento della lista
    #s1 => ultimo elemento della lista
    
    






firstTime:   
    la t0,initialSeed
    la t1,lfsr
    lh t0,0(t0)
    sh t0,0(t1)

getPseudoRandom:
    la t0,lfsr
    lh t0,0(t0)
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
    
    li t1,65536
    or t0,t0,t1
    
    la t1,lfsr
    sh t0,0(t1) #save new lfsr
    
checkFree:    
    lw t1,0(t0)
    bne t1,zero,getPseudoRandom #check byte 0-3 (PBACK)
    lb t1,4(t0)
    bne t1,zero,getPseudoRandom #check byte 4 (DATA)
    lw t1,4(t0)
    bne t1,zero,getPseudoRandom #check byte 5-8 (PAHEAD)
    
    add a0,t0,zero #save correct address
    jr ra
    
    
    