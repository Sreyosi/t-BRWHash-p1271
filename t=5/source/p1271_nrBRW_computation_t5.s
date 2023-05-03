.include "../source/p1271_macros.s"
.globl p1271_nrBRW_computation
p1271_nrBRW_computation:

/*Parameters passed to p1305_nrBRW_computation by caller: rdi=no of bits, rsi=points to input message, rdx= points to input key, rcx=points to output*/


subq $350, %rsp

movq %rbx, 16(%rsp)
movq %r12, 24(%rsp)
movq %r13, 32(%rsp)
movq %r14, 40(%rsp)
movq %r15, 48(%rsp)
movq %rbp, 56(%rsp)
movq %rdx, 72(%rsp)
movq %rcx, 104(%rsp)



/*compute no_of_15-byte-blocks*/
xorq %rdx, %rdx
movq %rdi, %rax
movq %rax, 112(%rsp)

/*** load the effective address of the memory where the squares have been stored ***/
leaq squares, %rdi
movq %rdi, 64(%rsp)
/**********************************************************************************/


movq $120, %r12
divq %r12 /* divq requires dividend to be in rdx:rax..returns quotient in rax and remainder in rdx */

/*increase no_of_blocks by 1 if there is imperfect last block*/
cmp $0, %rdx
je no_imperfect_block
inc %rax
no_imperfect_block: movq %rax, 80(%rsp)

movq $0, %r8
movq $0, %r9
movq $0, %r10
movq $0, %r11
movq $0, %r12
cmp $31, %rax
jle only_horner


     /**** For larger messages we need to compute number of chunks of blocks of input messages with number of look-ahead blocks(in this that no of look-ahead blocks is 32)********/ 
     comp_lookahead:    /*compute no of perfect chunks of look-ahead blocks*/

               
		
		xorq %rdx, %rdx
		movq $32, %r12
		divq %r12 
		movq %rdx, 80(%rsp)
		movq %rax, 88(%rsp) /*store the number of perfect look-ahead blocks*/
		
		
		/*leaq squares, %rdi
                movq %rdi, 64(%rsp)*/
       
    
    
     /* prepare stack and other iteration details*/
     movq $1, 96(%rsp)
   
     leaq stack, %r9 
     movq %r9, 160(%rsp)
     movq %r9, 168(%rsp)
     movq $0, 120(%rsp)

/*nrBRW Computation for messsages at least 32-block long*/
        
start:          movq 64(%rsp), %rdx
               
                /* m1+(tau) */
		
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r10, %rbp, %r9, %rbx
		
		addq $15, %rsi
		
		/*** m2+tau^2 ***/
	
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12, %r14, %r15
		addq $15, %rsi
		
		movq 0(%rsi), %r13
		movq 8(%rsi), %rax
		
		addq $15, %rsi
		
		/* m4+tau^4 */
	
		prepare_and_add_store  0(%rsi), 8(%rsi), 96(%rdx), 104(%rdx), 200(%rsp), 208(%rsp), %rdi
		addq $15, %rsi
		
		/*  m5+tau  */

		prepare_and_add 0(%rsi), 8(%rsi), %r10, %rbp, %rcx, %rdi
		addq $15, %rsi
		            
                /* m6+tau^2  */
                
                prepare_and_add_store 0(%rsi), 8(%rsi), %r11, %r12, 216(%rsp), 224(%rsp), %rbp
                addq $15, %rsi
 	
		BRW_7 %r9, %rbx, %r14, %r15, %r13, %rax, 200(%rsp), 208(%rsp), 232(%rsp),240(%rsp),248(%rsp),256(%rsp), 264(%rsp), %rcx, %rdi, 216(%rsp), 224(%rsp), 0(%rsi), 8(%rsi)
		addq $15, %rsi
		
		movq $0, %r12
		reduce %r8, %r9, %r10, %r11, %r12
		movq %r9, %rax
		
		movq 0(%rsi), %r14
		movq 8(%rsi), %r15
		andq mask56, %r15
		movq 64(%rsp), %rdx
		addq 112(%rdx), %r14
		adcq 120(%rdx), %r15
		
		mul_2x2 %r12, %rax, %r14, %r15 
		
		movq %r8, 224(%rsp)
		movq %r9, 232(%rsp)
		movq %r10, 240(%rsp)
		movq %r11, 248(%rsp)
		movq $0, 256(%rsp)
		
		addq $15, %rsi
		/**************************************************************************************************************************************************************************/
		movq 64(%rsp), %rdx
               
                /* m1+(tau) */
		
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r10, %rbp, %r9, %rbx
		
		addq $15, %rsi
		
		/*** m2+tau^2 ***/
	
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12, %r14, %r15
		addq $15, %rsi
		
		movq 0(%rsi), %r13
		movq 8(%rsi), %rax
		
		addq $15, %rsi
		
		/* m4+tau^4 */
	
		prepare_and_add_store  0(%rsi), 8(%rsi), 96(%rdx), 104(%rdx), 200(%rsp), 208(%rsp), %rdi
		addq $15, %rsi
		
		/*  m5+tau  */

		prepare_and_add 0(%rsi), 8(%rsi), %r10, %rbp, %rcx, %rdi
		addq $15, %rsi
		            
                /* m6+tau^2  */
                
                prepare_and_add_store 0(%rsi), 8(%rsi), %r11, %r12, 216(%rsp), 264(%rsp), %rbp
                addq $15, %rsi
 	
		BRW_7 %r9, %rbx, %r14, %r15, %r13, %rax, 200(%rsp), 208(%rsp), 272(%rsp),280(%rsp),288(%rsp),296(%rsp), 304(%rsp), %rcx, %rdi, 216(%rsp), 264(%rsp), 0(%rsi), 8(%rsi)
		addq $15, %rsi
		movq $0, %r12
		add_unreduced 224(%rsp), 232(%rsp), 240(%rsp), 248(%rsp), 256(%rsp)
		
		movq $0, %r12
		reduce %r8, %r9, %r10, %r11, %r12
		movq %r9, %rax
		
		movq 0(%rsi), %r14
		movq 8(%rsi), %r15
		andq mask56, %r15
		movq 64(%rsp), %rdx
		addq 128(%rdx), %r14
		adcq 136(%rdx), %r15
		
		mul_2x2 %r12, %rax, %r14, %r15 
		
		movq %r8, 224(%rsp)
		movq %r9, 232(%rsp)
		movq %r10, 240(%rsp)
		movq %r11, 248(%rsp)
		
		movq $0, 256(%rsp)
		addq $15, %rsi
		
	
		/*******************************************************************************************************************************************************************************/
		movq 64(%rsp), %rdx
               
                /* m1+(tau) */
		
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r10, %rbp, %r9, %rbx
		
		addq $15, %rsi
		
		/*** m2+tau^2 ***/
	
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12, %r14, %r15
		addq $15, %rsi
		
		movq 0(%rsi), %r13
		movq 8(%rsi), %rax
		
		addq $15, %rsi
		
		/* m4+tau^4 */
	
		prepare_and_add_store  0(%rsi), 8(%rsi), 96(%rdx), 104(%rdx), 200(%rsp), 208(%rsp), %rdi
		addq $15, %rsi
		
		/*  m5+tau  */

		prepare_and_add 0(%rsi), 8(%rsi), %r10, %rbp, %rcx, %rdi
		addq $15, %rsi
		            
                /* m6+tau^2  */
                
                prepare_and_add_store 0(%rsi), 8(%rsi), %r11, %r12, 216(%rsp), 264(%rsp), %rbp
                addq $15, %rsi
 	
		BRW_7 %r9, %rbx, %r14, %r15, %r13, %rax, 200(%rsp), 208(%rsp), 272(%rsp),280(%rsp),288(%rsp),296(%rsp), 304(%rsp), %rcx, %rdi, 216(%rsp), 264(%rsp), 0(%rsi), 8(%rsi)
		addq $15, %rsi
		
		movq $0, %r12
		reduce %r8, %r9, %r10, %r11, %r12
		movq %r9, %rax
		
		movq 0(%rsi), %r14
		movq 8(%rsi), %r15
		andq mask56, %r15
		movq 64(%rsp), %rdx
		addq 112(%rdx), %r14
		adcq 120(%rdx), %r15
		
		mul_2x2 %r12, %rax, %r14, %r15
		movq $0, %r12
		add_unreduced 224(%rsp), 232(%rsp), 240(%rsp), 248(%rsp), 256(%rsp) 
		movq %r8, 224(%rsp)
		movq %r9, 232(%rsp)
		movq %r10, 240(%rsp)
		movq %r11, 248(%rsp)
		movq %r12, 256(%rsp)
		
		addq $15, %rsi
		
		/**************************************************************************************************************************************************************************/
		movq 64(%rsp), %rdx
               
                /* m1+(tau) */
		
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r10, %rbp, %r9, %rbx
		
		addq $15, %rsi
		
		/*** m2+tau^2 ***/
	
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12, %r14, %r15
		addq $15, %rsi
		
		movq 0(%rsi), %r13
		movq 8(%rsi), %rax
		
		addq $15, %rsi
		
		/* m4+tau^4 */
	
		prepare_and_add_store  0(%rsi), 8(%rsi), 96(%rdx), 104(%rdx), 200(%rsp), 208(%rsp), %rdi
		addq $15, %rsi
		
		/*  m5+tau  */

		prepare_and_add 0(%rsi), 8(%rsi), %r10, %rbp, %rcx, %rdi
		addq $15, %rsi
		            
                /* m6+tau^2  */
                
                prepare_and_add_store 0(%rsi), 8(%rsi), %r11, %r12, 216(%rsp), 264(%rsp), %rbp
                addq $15, %rsi
 	
		BRW_7 %r9, %rbx, %r14, %r15, %r13, %rax, 200(%rsp), 208(%rsp), 272(%rsp),280(%rsp),288(%rsp),296(%rsp), 304(%rsp), %rcx, %rdi, 216(%rsp), 264(%rsp), 0(%rsi), 8(%rsi)
		addq $15, %rsi
		movq $0, %r12
		add_unreduced 224(%rsp), 232(%rsp), 240(%rsp), 248(%rsp), 256(%rsp)
		
		
		check_stack: movq 96(%rsp), %rbp
    	
                		movq $0, %r13
               
				shrq $1, %rbp
				jc common
				movq 160(%rsp), %r14
			
		loop1:         add_unreduced -40(%r14), -32(%r14), -24(%r14), -16(%r14), -8(%r14)
						
			       inc %r13
                              subq $40, %r14
                              shrq $1, %rbp

        			jnc loop1
        			
        			movq %r14, 160(%rsp)
                
		common:  addq $1, 96(%rsp)
		
		reduce %r8, %r9, %r10, %r11, %r12
	
		
               movq %r9, %rax
                       
		movq 64(%rsp), %rdx
     		addq $144, %rdx
               
		imul $16, %r13, %r13
		addq %r13, %rdx
		
		movq 0(%rsi), %r14
		movq 8(%rsi), %r15
		andq mask56, %r15
		
		addq 0(%rdx), %r14
		adcq 8(%rdx), %r15
		 
		
		
    		mul_2x2  %r12, %rax, %r14, %r15   
    				
    		movq $0, %r12
    		
    		
		movq 96(%rsp), %rcx
		
		
		movq 160(%rsp), %rdi
		
		
		addq $15, %rsi
		
		
		
		movq %r8,0(%rdi)
		movq %r9,8(%rdi)
		movq %r10, 16(%rdi)
		movq %r11, 24(%rdi)
		movq %r12, 32(%rdi)
		
		
		cmp %rcx, 88(%rsp)
		
		jl common1
		
		
		addq $40, 160(%rsp)
		
	        
                              
                jmp start
                               


   
   		
   		
      common1:  movq 160(%rsp), %r14
    		 movq 168(%rsp), %r13

		
                

        loop3:  cmp %r13, %r14
                jle horner
               
                add_unreduced -40(%r14), -32(%r14), -24(%r14), -16(%r14), -8(%r14)
		
                subq $40, %r14
    		        
                        
                jmp loop3

      
	
   horner: movq 80(%rsp), %rcx /*check how many blocks are left...only one case will be satisfied*/
        
	cmpq $0, %rcx
	je final_reduction
	
	reduce_2 %r8, %r9, %r10, %r11, %r12
		
	/* #blocks = 1 */
        cmpq    $1,%rcx
	je      S1

	
	/* #blocks = 2 */
	 cmpq    $2,%rcx
	je      S2
	
	/* #blocks = 3 */
	cmpq    $3,%rcx
	je      S3
	
	/* #blocks = 4 */
	cmpq    $4,%rcx
	je      S4
	
	/* #blocks = 5 */
	cmpq    $5,%rcx
	je      S5
	
	/* #blocks = 6 */
	cmpq    $6,%rcx
	je      S6
	
	/* #blocks = 7 */
	cmpq    $7,%rcx
	je      S7
	
	S8:     movq    64(%rsp),%rdi
		horner_mul_2x2_initial 112(%rdi), 120(%rdi), %r12, %r11
		movq $0, %r12
		jmp LB8
	
	
	S1: 	movq    64(%rsp),%rdi
		horner_mul_2x2_initial 0(%rdi), 8(%rdi), %r12, %r11
		movq $0, %r12
		movq 8(%rsi), %rbx
		andq mask56, %rbx
		addq 0(%rsi), %r8
		adcq %rbx, %r9
		adcq $0, %r10
		adcq $0, %r11
		adcq $0, %r12
		
		
		addq $15, %rsi
		
		jmp final_reduction
	
	S2: 	movq    64(%rsp),%rdi
		horner_mul_2x2_initial 16(%rdi), 24(%rdi), %r12, %r11
		movq $0, %r12
		horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
		add_unreduced %r13, %r14, %r15, %rax, $0
		addq $15, %rsi
		movq 8(%rsi), %rbx
		andq mask56, %rbx
		add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
		jmp final_reduction
		
	S3: 	movq    64(%rsp),%rdi
		
		horner_mul_2x2_initial 32(%rdi), 40(%rdi), %r12, %r11
		movq $0, %r12
		horner_mul_2x2 0(%rsi), 8(%rsi), 16(%rdi), 24(%rdi)
		addq $15, %rsi
		add_unreduced %r13, %r14, %r15, %rax, $0
	
		horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
		
		add_unreduced %r13, %r14, %r15, %rax, $0
		addq $15, %rsi
		movq 8(%rsi), %rbx
		andq mask56, %rbx
		add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
		
		jmp final_reduction
	
	S4: 	movq    64(%rsp),%rdi
		horner_mul_2x2_initial 96(%rdi), 104(%rdi), %r12, %r11
		movq $0, %r12
		jmp LB4
	
	S5: 	movq    64(%rsp),%rdi
		horner_mul_2x2_initial 48(%rdi), 56(%rdi), %r12, %r11
		movq $0, %r12
		jmp LB5
 
	S6: 	movq    64(%rsp),%rdi
		horner_mul_2x2_initial 64(%rdi), 72(%rdi), %r12, %r11
		movq $0, %r12
		jmp LB6
 
	S7: 	movq    64(%rsp),%rdi
		horner_mul_2x2_initial 80(%rdi), 88(%rdi), %r12, %r11
		movq $0, %r12
		jmp LB7
	
	
       only_horner: movq    64(%rsp),%rdi
       
	movq 80(%rsp), %rcx
	/* #blocks = 1 */
        cmpq    $1,%rcx
	je      LB1

	
	/* #blocks = 2 */
	cmpq    $2,%rcx
	je      LB2
	
	/* #blocks = 3 */
	cmpq    $3,%rcx
	je      LB3
	
	/* #blocks = 4 */
	cmpq    $4,%rcx
	je      LB4
	
	/* #blocks = 5 */
	cmpq    $5,%rcx
	je      LB5
	
	/* #blocks = 6 */
	cmpq    $6,%rcx
	je      LB6
	
	/* #blocks = 7 */
	cmpq    $7,%rcx
	je      LB7
	
LB8:	/* m1*tau^7 */
	movq 64(%rsp), %rdi
	one: horner_mul_2x2 0(%rsi), 8(%rsi), 80(%rdi), 88(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^7 + m2*tau^6 */
	
	two: horner_mul_2x2 0(%rsi), 8(%rsi), 64(%rdi), 72(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 */
	
	three: horner_mul_2x2 0(%rsi), 8(%rsi), 48(%rdi), 56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 */
	
	four: horner_mul_2x2 0(%rsi), 8(%rsi), 96(%rdi), 104(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 */
	
	five: horner_mul_2x2 0(%rsi), 8(%rsi), 32(%rdi), 40(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 */
	
	six: horner_mul_2x2 0(%rsi), 8(%rsi), 16(%rdi), 24(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 + m7*tau */
	seven: horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	movq 8(%rsi), %rbx
	andq mask56, %rbx
	
	addq 0(%rsi),%r8
	adcq %rbx, %r9
	adcq $0, %r10
	adcq $0, %r11
	adcq $0, %r12
	
	addq $15, %rsi

	
	
	
	movq    80(%rsp),%rcx
	subq    $8,%rcx
	movq    %rcx,80(%rsp)	
	
	/* #blocks = 0 */	
	cmpq    $0,%rcx	
	je      final_reduction
	
	reduce_2 %r8, %r9, %r10, %r11, %r12
	
	
	/* #blocks > 1 */
	cmpq    $1,%rcx	
	jne     LT2
	
LT1:
	/* tau*(m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 + m7*tau + m8) */
	
	horner_mul_2x2_initial 0(%rdi), 8(%rdi),%r12, %r11
	movq $0, %r12
		
		movq 8(%rsi), %rbx
		andq mask56, %rbx

		addq 0(%rsi), %r8
		adcq %rbx, %r9
		adcq $0, %r10
		adcq $0, %r11
		adcq $0, %r12
		
		
	
	
	jmp     final_reduction
	movq 64(%rsp), %rdi
LT2:
	/* #blocks > 2 */
	cmpq    $2,%rcx	
	jne     LT3	
	addq    $16,%rdi
	jmp     LMULT

LT3:
	/* #blocks > 3 */
	cmpq    $3,%rcx
	jne     LT4
	/* #blocks = 3 */
	addq    $32,%rdi
	jmp     LMULT

LT4:
	/* #blocks > 4 */
	cmpq    $4,%rcx
	jne     LT5
	/* #blocks = 4 */	
	addq    $96,%rdi
	jmp     LMULT

LT5:
	/* #blocks > 5 */
	cmpq    $5,%rcx
	jne     LT6
	/* #blocks = 5 */	
	addq    $48,%rdi
	jmp     LMULT

LT6:
	/* #blocks > 6 */
	cmpq    $6,%rcx
	jne     LT7
	/* #blocks = 6 */	
	addq    $64,%rdi
	jmp     LMULT

LT7:
	/* #blocks > 7 */
	cmpq    $7,%rcx
	jne     LT8
	/* #blocks = 7 */	
	addq    $80,%rdi
	jmp     LMULT

LT8:
	/* #blocks >= 8 */
	addq    $112,%rdi

LMULT:

	/* tau^n*(m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 + m7*tau + m8) */
	horner_mul_2x2_initial 0(%rdi), 8(%rdi),%r12, %r11
	movq $0, %r12
	
	/* #blocks = 2 */
	cmpq    $2,%rcx
	je      LB2
	
	/* #blocks = 3 */
	cmpq    $3,%rcx
	je      LB3
	
	/* #blocks = 4 */
	cmpq    $4,%rcx
	je      LB4
	
	/* #blocks = 5 */
	cmpq    $5,%rcx
	je      LB5
	
	/* #blocks = 6 */
	cmpq    $6,%rcx
	je      LB6
	
	/* #blocks = 7 */
	cmpq    $7,%rcx
	je      LB7
	
	/* #blocks >= 8 */
	jmp     LB8
		
LB2:	/* m1*tau */
	movq 64(%rsp), %rdi
	horner_mul_2x2	0(%rsi),	8(%rsi),	0(%rdi),	8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	movq 8(%rsi), %rbx
	andq mask56, %rbx

	add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
	jmp final_reduction
	
LB3:
	/*movq    88(%rsp),%rsi*/
	movq 64(%rsp), %rdi
	
	/* m1*tau^2 */
	
	horner_mul_2x2	0(%rsi), 8(%rsi), 16(%rdi), 24(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
		
	/* m1*tau^2 + m2*tau */
	
	horner_mul_2x2	0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	movq 8(%rsi), %rbx
	andq mask56, %rbx

	add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
	jmp     final_reduction
	
LB4:	/*movq    88(%rsp),%rsi*/
	
	movq 64(%rsp), %rdi
	
	/* m1*tau^3 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 32(%rdi), 40(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^3 + m2*tau^2 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 16(%rdi), 24(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^3 + m2*tau^2 + m3*tau */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	movq 8(%rsi), %rbx
	andq mask56, %rbx

	add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
	jmp final_reduction
	
LB5:
	/*movq    88(%rsp),%rsi*/
	movq 64(%rsp), %rdi

	/* m1*tau^4 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi),  96(%rdi), 104(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^4 + m2*tau^3 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 32(%rdi),40(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^4 + m2*tau^3 + m3*tau^2 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 16(%rdi),24(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0	
	addq $15, %rsi
	
	/* m1*tau^4 + m2*tau^3 + m3*tau^2 + m4*tau */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi),8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	movq 8(%rsi), %rbx
	andq mask56, %rbx

	add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
	jmp final_reduction
	
LB6:/*movq    88(%rsp),%rsi*/

	movq 64(%rsp), %rdi
	/* m1*tau^5 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 48(%rdi), 56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^5 + m2*tau^4 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 96(%rdi),104(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^5 + m2*tau^4 + m3*tau^3 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 32(%rdi),40(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^5 + m2*tau^4 + m3*tau^3 + m4*tau^2 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 16(%rdi),24(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^5 + m2*tau^4 + m3*tau^3 + m4*tau^2 + m5*tau */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi),8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	movq 8(%rsi), %rbx
	andq mask56, %rbx

	add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
	jmp final_reduction
	
LB7:	movq 64(%rsp), %rdi

	/* m1*tau^6 */
	
	horner_mul_2x2 0(%rsi),8(%rsi),64(%rdi), 72(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^6 + m2*tau^5 */
	horner_mul_2x2 0(%rsi), 8(%rsi), 48(%rdi), 56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 96(%rdi),104(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 + m4*tau^3 */
	
	horner_mul_2x2 0(%rsi), 8(%rsi), 32(%rdi), 40(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 + m4*tau^3 + m5*tau^2 */
	
	horner_mul_2x2	0(%rsi),	8(%rsi),	16(%rdi),	24(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 + m4*tau^3 + m5*tau^2 + m6*tau */
	
	horner_mul_2x2	0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	addq $15, %rsi
	
	movq 8(%rsi), %rbx
	andq mask56, %rbx

	add_unreduced 0(%rsi), %rbx, $0, $0, $0
	
	jmp final_reduction
		
	
	
LB1:   
	/* key = (r15 : r14) */
	/* message block = (rax : r13) */
	
	movq 8(%rsi), %rbx
	and mask56, %rbx
	addq    0(%rsi),%r8
	adcq    %rbx, %r9
	adcq    $0, %r10
	adcq    $0, %r11
	adcq    $0, %r12
	
	



final_reduction: reduce_2 %r8, %r9, %r10, %r11, %r12
	
L3:	/* final computation */
	movq 64(%rsp), %rsi
	
	mul_2x2 16(%rsi), 24(%rsi), %r12, %r11
	
	movq 112(%rsp), %rdx
        movq $0, %r12
	
	movq 0(%rsi), %rax
	movq 8(%rsi), %rbx
        
	mulx %rax, %rcx, %r15
	
	mulx %rbx, %rdi, %rsi
	adcx %rdi, %r15
	adcx zero, %rsi

	add_unreduced %rcx, %r15, %rsi, $0, $0
        
       
        
       fr: reduce %r8, %r9, %r10, %r11, %r12
       r:	movq $0, %rax
		shld $1, %r9, %rax
 		and mask63, %r9
 		
 		addq %rax, %r12
 		adcq $0, %r9
	
		movq    %r12, %r11			
		movq    %r9, %rcx	
						
		subq    p0, %r12			
		sbbq    p1,%r9			
						
		movq    %r9,%r10			
		shlq    $1,%r10			
						
		cmovc   %r11,%r12			
		cmovc   %rcx, %r9			

	        andq mask62, %r9
	        
		/*final result*/
    		final_result: movq 104(%rsp), %rsi

    		movq %r12,0(%rsi) 
    		movq %r9,8(%rsi) 

	
	
	
		  
movq 16(%rsp), %rbx
movq 24(%rsp), %r12
movq 32(%rsp), %r13
movq 40(%rsp), %r14
movq 48(%rsp), %r15
movq 56(%rsp), %rbp


addq $350, %rsp

ret

