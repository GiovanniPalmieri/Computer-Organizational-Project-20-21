#pseudo random generator
.data 
initialSeed: .half 60
lfsr:        .half 00
listInput:    .string "ADD{b}~  ADD{a}  ~ADD{B}~ADD{A}~ADD{3}~ADD{2}~ADD{C}~ADD{c}~ADD{1}~PRINT~SORT~PRINT~~"

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
    li t1,68
    beq t0,t1,callDel
    li t1,82
    beq t0,t1,callRev
    li t1,83
    beq t0,t1,callSort
    beq zero,t0,end
    addi s1,s1,1
    j mainLoop
    
callSort:
    #per prima cosa devo contare gli elementi in s2
    add s2,zero,zero
    add t0,s0,zero
    j countLoop
    
incrementCountLoop:  
    add t0,t1,zero  
countLoop:
    addi s2,s2,1
    lw t1,5(t0)
    li t2,-1
    bne t1,t2,incrementCountLoop
    #finito di contare
    addi s2,s2,-1 #il bubble sort deve girare count-1 volte
sortMainCycle:
    #per ogni elemento devo fare un ciclo di sorting
    addi s2,s2,-1
    jal bubbleSort
    bne s2,zero,sortMainCycle
    j exitSort

exitSort: 
    addi s1,s1,5
    j mainLoop  
    
bubbleSort:
    add t0,s0,zero #in t0 metto il puntatore al primo elemento
loopBubbleSort:
    lw t1,5(t0) #in t1 metto il puntatore all'elemento successivo
    li t2,-1
    beq t2,t1,exitBubbleSort #se sono alla fine esco
    #altrimenti confronto gli elementi
    #salvo i registri nello stack
    addi sp,sp,-12
    sw t0,0(sp)
    sw t1,4(sp)
    sw ra,8(sp)
    
    add a0,t0,zero
    add a1,t1,zero
 
    jal swap
    
    lw t0,0(sp)
    lw t1,4(sp)
    lw ra,8(sp)
    addi sp,sp,12
    
    add t0,t1,zero #punto all'elemento successivo e continuo il ciclo
    j loopBubbleSort
    
    
exitBubbleSort:
    jr ra
    
    
    
    
swap: #a0 first node, a1 second node
    #leggo i valori
    lb t0,4(a0) 
    lb t1,4(a1)
    
    addi sp,sp,-20
    sw a0,0(sp)
    sw a1,4(sp)
    sw t0,8(sp)
    sw t1,12(sp)
    sw ra,16(sp)

    add a0,t0,zero
    add a1,t1,zero
    
    jal getOrderValue
    
    add t2,a0,zero
    add t3,a1,zero
    
    lw a0,0(sp)
    lw a1,4(sp)
    lw t0,8(sp)
    lw t1,12(sp)
    lw ra,16(sp)
    addi sp,sp,20
    
    bge t3,t2,swapReturn #se il secondo valore è più grande del primo non è necessario fare lo swap
    #non sono in ordine percio scambio i valori
    sb t0,4(a1)
    sb t1,4(a0)
    
swapReturn:
    
    jr ra
    
    
    
getOrderValue: #a0 firstValue, a1 secondValue
    li t0,122
    bgt a0,t0,secondValue
    li t0,97
    bge a0,t0,lowerCaseFirst
    li t0,90
    bgt a0,t0,secondValue
    li t0,65
    bge a0,t0,upperCaseFirst
    li t0,57
    bgt a0,t0,secondValue
    li t0,48
    bge a0,t0,numberFirst
    j secondValue
    
numberFirst:
    addi a0,a0,78
    j secondValue
    
upperCaseFirst:
    addi a0,a0,97
    j secondValue

lowerCaseFirst:
    addi a0,a0,39
    j secondValue    

    
secondValue:
    li t0,122
    bgt a1,t0,exitGetOrder
    li t0,97
    bge a1,t0,lowerCaseSecond
    li t0,90
    bgt a1,t0,exitGetOrder
    li t0,65
    bge a1,t0,upperCaseSecond
    li t0,57
    bgt a1,t0,exitGetOrder
    li t0,48
    bge a1,t0,numberSecond
    j exitGetOrder
    
numberSecond:
    addi a1,a1,78
    j exitGetOrder
    
upperCaseSecond:
    addi a1,a1,97
    j exitGetOrder

lowerCaseSecond:
    addi a1,a1,39
    j exitGetOrder
exitGetOrder:    
    jr ra    

    
callRev:
    addi s1,s1,4 #incremento il puntantore dell'input alla prossima istruzione
    add t0,s0,zero #metto in t0 il puntatore all'inizio lista

loopRev:
    #controllo che non sia l'ultimo elemento
    lw t1,5(t0)
    li t2,-1
    beq t1,t2,exitLoopRev
    #se non è l'ultimo elemento scambio i puntatori
    lw t2,0(t0) #prendo il pback dell'elemento corrente
    sw t2,5(t0)
    sw t1,0(t0) #scambio i puntatori
    add t0,t1,zero #passo al prossimo nodo
    j loopRev
    
    
exitLoopRev:
    #scambio comunque i puntatori dell'ultimo
    lw t1,0(t0)
    lw t2,5(t0)
    sw t2,0(t0)
    sw t1,5(t0)
    #aggiorno l'inizio lista
    add s0,t0,zero
    j mainLoop

callDel:
    lb t1,4(s1)# metto in t1 il valore da cercare    
    add t0,s0,zero #metto il t0 il puntatntore al nodo corrente
    addi s1,s1,7 #incremento il puntatore all'input
    
loopDel:
    lb t2,4(t0)
    beq t1,t2,removeValue
    lw t0,5(t0) #t0 ora punta al nodo successivo
    #controllo se sono arrivato alla fine
    li t3,-1
    beq t3,t0,exitDel
    j loopDel
      
removeValue:
    lw t1,5(t0) #leggo il puntatore per controllare se è l'ultimo
    li t3,-1
    beq t3,t1,removeLast
    #non è l'ultimo valore
    lw t2,0(t0)
    #t0 nodo da rimuovere
    #t1 nodo successivo
    #t2 nodo precedente
    sw t1,5(t2)
    sw t2,0(t1)
    j exitDel
    
removeLast:
    lw t2,0(t0) #t2 nodo precentene
    sw t3,5(t2) #t2 è il fine
    j exitDel

exitDel:
    
    j mainLoop    
    
    
callPrint:
    add t0,s0,zero #metto in t0 il puntantore al nodo corrente
    addi s1,s1,6
loopPrint:
    lb a0,4(t0) #leggo il valore
    li a7,11
    ecall
    lw t1,5(t0) #leggo il puntatore al prossimo elemento
    li t2,-1
    beq t2,t1,exitPrint #se ultimo elemento torno al main 
    add t0,t1,zero
    j loopPrint
 
exitPrint:  
    #stampo una newLine
    li a0,10
    li a7,11
    ecall
    j mainLoop
       
    
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
    li t2,-1
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
    li t1,-1
    sw t1,5(a0) #aggiorno il pahead dell'ultimo elemento
    
    
    j mainLoop

addFirstValue:
    add a1,a0,zero #metto il valore in a1
    jal getPseudoRandom #prendo l'indirizzo di memoria
    li t0,-1 #primo ed ultimo elemento perciò ffffffff
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