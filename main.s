#pseudo random generator
.data 
initialSeed: .half 60
lfsr:        .half 00
listInput:    .string "ADD{1}~ADD{a}~ADD{b}~ADD{c}~ADD{d}~PRINT"
maxPointer: .word -1



.text    



main:
    #s0 => primo elemento della lista
    #s1 => puntatore a list input
    la s1,listInput

mainLoop:    
    lb t0,0(s1)
    li t1,65
    beq t0,t1,callAdd
    li t1,80
    beq t0,t1,callPrint
    
callPrint:
    add t0,s0,zero #metto in t0 il puntantore al nodo corrente
loopPrint:
    lb a0,4(t0) #leggo il valore
    li a7,11
    ecall
    lw t1,5(t0) #leggo il puntatore al prossimo elemento
    la t2,maxPointer
    lw t2,0(t2)
    beq t2,t1,end #se ultimo elemento torno al main -----jump main loop
    add t0,t1,zero
    j loopPrint
    
    
    
    
callAdd:
    #leggo il valore da aggiungere
    lb a0,4(s1) #il valora si trova 4 byte dopo
    addi s1,s1,7 #imposto per dopo il puntatore al comando successivo
    j Add

Add:
    beq s0,zero,addFirstValue #controllo se la lista è vuota
    #se non è vuota cerco l'ultimo elemento
    add t0,s0,zero # metto il puntatore al primo elemento in s2
next:   
    lw t1,5(t0)#t1 <- prossimo
    la t2,maxPointer
    lw t2,0(t2)
    add a1,t0,zero
    beq t1,t2,addLast
    add t0,t1,zero # corrente <- prossimo
    j next
    
    

addLast:  
    add a3,a0,zero #metto value in a3
    jal getPseudoRandom #ora in a0 ho il nuovo inidirizzo
    sw a0,5(a1) # aggiorno il pahead del penultimo elemento   
    sw a1,0(a0) #aggiorno il pback dell'ultimo elemento 
    sb a3,4(a0) #salvo il value
    la t1,maxPointer
    lw t1,0(t1)
    sw t1,5(a0) #aggiorno il pahead dell'ultimo elemento
    
    
    j mainLoop

addFirstValue:
    add a1,a0,zero #metto il valore in a1
    jal getPseudoRandom #prendo l'indirizzo di memoria
    la t0,maxPointer #primo ed ultimo elemento perciò ffffffff
    lw t0,0(t0)
    sw t0,0(a0)
    sb a1,4(a0)
    sw t0,5(a0)
    add s0,a0,zero #metto in s0 il puntatore al primo elemento
    j mainLoop

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
    
    
end:
    add t0,t0,zero