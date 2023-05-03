.macro horner_mul_2x2 m1, m2, m3, m4


	xorq    %rcx,%rcx
	movq    \m1,%rdx    

	mulx    \m3,%r13,%r14
	mulx    \m4,%rbx,%r15	
	adcx    %rbx,%r14
	adcx    zero, %r15
	 
	xorq    %rdx,%rdx
	movq    \m2,%rdx    
	andq    mask56, %rdx
	
	mulx    \m3,%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	
	mulx    \m4,%rbx,%rax
	adcx    %rbx,%r15
	adox    zero, %rax
	adcx    zero, %rax
	
.endm

.macro horner_mul_3x2 m1, m2, m3, m4, m5
	xorq    %r14,%r14
	movq    \m1,%rdx    

	mulx    \m4,%r8,%r12
	mulx    \m5,%rbx,%r13
	adcx    %rbx,%r12
	adcx    %r14,%r13

	xorq    %rax,%rax
	movq    \m2,%rdx
	   
	mulx    \m4,%r9,%rbp
	adcx    %r12,%r9
	adox    %rbp,%r13
	    
	mulx    \m5,%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14
	adcx    %rax,%r14

	xorq    %r12,%r12
	movq    \m3,%rdx
	    
	mulx    \m4,%r10,%rbp
	adcx    %r13,%r10
	adox    %rbp,%r14
	    
	mulx    \m5,%r11,%rbp
	adcx    %r14,%r11
	adox    %rbp,%r12
	adcx    %rax,%r12
.endm

.macro horner_mul_2x2_initial m1, m2, m3, m4

		movq \m1, %rdx
		
		mulx 	\m3, %r8, %r14

		mulx 	\m4, %rbp, %r10
		adcx 	%rbp, %r14
		adcx	zero, %r10
		
		
		movq \m2, %rdx
		

		mulx \m3, %r9, %rax
		adcx %r14, %r9
		adox %rax, %r10

		mulx \m4, %rbp, %r11
		adcx %rbp, %r10
		adox zero, %r11
		adcq $0, %r11
		
	
	   
.endm

.macro reduce_1 s1,s2,s3,s4,s5
 movq $0, \s5
 shld $1, \s3, \s4
 shlq $1, \s3
 
 addq \s3, \s1
 adcq \s4, \s2
 adcq $0, \s5
 
 shld $1, \s2,\s5
 
 and mask63, \s2
 
 addq \s5, \s1
 adcq $0, \s2
		
.endm

.macro reduce_2 s1,s2,s3,s4,s5
 shld $1, \s4, \s5
 shld $1, \s3, \s4
 shlq $1, \s3
 
 addq \s3, \s1
 adcq \s2, \s4
 adcq $0, \s5
 
 shld $1, \s4,\s5
 
 and mask63, \s4
 
 addq \s1, \s5
 adcq $0, \s4
		
.endm

.macro reduce s1,s2,s3,s4,s5

 shld $1, \s4, \s5
 shld $1, \s3, \s4
 shlq $1, \s3
 
 addq \s3, \s1
 adcq \s4, \s2
 adcq $0, \s5
 
 shld $1, \s2,\s5
 
 and mask63, \s2
 
 addq \s1, \s5
 adcq $0, \s2
		
.endm

.macro mul_2x2 r1, r2, r3, r4

		movq \r1, %rdx
		
		mulx 	\r3, %r8, %r9

		mulx 	\r4, %rbp, %r10
		adcx 	%rbp, %r9
		adcx	zero, %r10
		
		
		movq \r2, %rdx
		

		mulx \r3, %rbp, %r12
		adcx %rbp, %r9
		adox %r12, %r10

		mulx \r4, %rbp, %r11
		adcx %rbp, %r10
		adox zero, %r11
		adcq $0, %r11
		
.endm

.macro add_unreduced x1, x2, x3, x4, x5

		addq \x1, %r8
		adcq \x2, %r9
		adcq \x3, %r10
		adcq \x4, %r11
		adcq \x5, %r12
		
.endm

.macro BRW_4 p1, p2, p3, p4, p5, p6, p7, p8

		mul_2x2 \p1,	\p2,	\p3,	\p4
		movq $0, %r12
		
		
		
		add_unreduced \p5, \p6, $0, $0, $0
		
		reduce %r8, %r9, %r10, %r11, %r12
    	  
    	  	movq %r9, %r14
    	  
    	  		  	
    	  	mul_2x2 %r12, %r14, \p7, \p8
    	        movq $0, %r12
		
 
.endm
.macro BRW_2 m1, m2, m3, m4

	  movq 64(%rsp), %rdi
	  movq 0(%rdi), %rdx
	
	  mulx \m1, %r8, %r9

	  mulx \m2, %r10, %r11
	  adcx %r10, %r9
	  adcx zero, %r11
	  
	  movq 8(%rdi), %rdx
          
	  mulx \m1, %rbp, %r10
          adcx %rbp, %r9
	  adox %r11, %r10

          mulx \m2, %rbp, %r11
          adcx %rbp, %r10
          adox zero, %r11
          adcq $0, %r11
          
          movq $0, %r12
          
          add_unreduced \m3, \m4, $0, $0, $0
          
.endm
.macro	BRW_3	p1,	p2,	p3,	p4,	p5,	p6
		
		
		mul_2x2 \p1,	\p2,	\p3,	\p4
		movq $0, %r12
		movq \p6, %rdx
		andq mask56, %rdx
		add_unreduced \p5, %rdx, $0, $0, $0
		
		
.endm
		
.macro	BRW_7	q1,	q2,	q3,	q4,	q5,	q6,	q7,	q8,	q9,	q10,	q11,	q12,	q13,	q14,	q15,	q16,	q17,	q18,	q19,	q20,	q21,	q22

		BRW_3 \q1, \q2, \q3, \q4, \q5, \q6
		
		reduce %r8, %r9, %r10, %r11, %r12
		
		movq %r9, %rbx
		
		
		mul_2x2 %r12, %rbx, \q7, \q8 
						
		movq %r8, \q9
		movq %r9, \q10
		movq %r10, \q11
		movq %r11, \q12
		movq $0, \q13
		
		BRW_3 	\q14,	\q15,	\q16, 	\q17,	\q18,	\q19
		
		
		
		add_unreduced \q9, \q10, \q11, \q12, \q13
		
		
				
		
		
.endm

.macro prepare_and_add_store_1 a1, a2, k1, k2, s1, s2

		movq \a1, \s1
		movq \a2, \s2
	        
		
		movq \k1, %r11
		movq \k2, %r12
		
			
		addq %r11, \s1
		adcq %r12, \s2
		
		

.endm

.macro prepare_and_add a1, a2, k1, k2, s1, s2
                
                movq \a1, \s1
                movq \a2, \s2
                andq mask56, \s2
		
		addq \k1, \s1
		adcq \k2, \s2

		
		
.endm


.macro prepare_and_add_store a1, a2, k1, k2, s1, s2, t
                
               movq \a1, \t
               movq \a2, %r8
               andq mask56, %r8
               
		addq \k1, \t
		adcq \k2, %r8
		
		movq \t, \s1
		movq %r8, \s2
		
	
.endm

.macro prepare_and_add_2 d1, d2

		addq \d1, %r11
		adcq \d2, %r12
				

.endm

.macro prepare_and_add_store_2 a1, a2, k1, k2, s1, s2

		movq \a1, %rbp
		movq \a2, %r8
				
		movq \k1, %r11
		movq \k2, %r12
			
		addq %r11, %rbp
		adcq %r12, %r8
		
		movq %rbp, \s1
		movq %r8, \s2
		
		

.endm

.macro prepare_and_add_store_3 a1, a2, k1, k2, t1, t2, s1, s2

		movq \a1, \s1
		movq \a2, \s2
		andq mask56, \s2
				
		movq \k1, \t1
		movq \k2, \t2
			
		addq \t1, \s1
		adcq \t2, \s2		
		
		

.endm

