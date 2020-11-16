.global _start

.data
temp:
	.long 0
string1:
	.space 100
string2:
	.space 100
buf:
	.space 404
curDist:
	.space 404
oldDist:
	.space 404
	

.equ max, 404
.equ ws, 4
.equ cs, 1
.text

_start:
    prologue:
	    push %ebp
	    movl %esp, %ebp
    	subl $5*ws, %esp
	    push %ebx
    	push %esi

	    # Locals
    	.equ strlen1,  (-1*ws) #(%ebp)
	    .equ strlen2, (-2*ws) #(%ebp)
    	.equ i, (-3*ws) #(%ebp)
	    .equ j, (-4*ws) #(%ebp)
    	.equ min, (-5*ws) #(%ebp)
	/*
  	int word1_len = strlen(word1);
 	int word2_len = strlen(word2);
  	*/
  	movl $1, buf
  	mov string1, %edx
  	call stringLen
  	addl $1, %eax
  	movl %eax, strlen1(%ebp)
  	
  	movl $2, buf 
  	mov string2, %edx 
  	call stringLen 
  	addl $1, %eax 
  	movl %eax, strlen2(%ebp) 
  	
  	movl $0, i(%ebp)
  	
  	single_for:
  	  	#for(i = 0; i < word2_len + 1; i++){
  		movl i(%ebp), %eax
  		cmpl strlen2(%ebp),%eax 
  		jge single_for_end
  		
  		#oldDist[i] = i;
   		#curDist[i] = i;
   		movl i(%ebp), %eax
  		movl %eax, curDist(,%eax,ws)
  	
  		movl %eax, oldDist(,%eax,ws)
  		
  		inc %eax
  		movl %eax, i(%ebp)
  		jmp single_for
  	
  	single_for_end: 
  	
  	
  	movl $1, i(%ebp)
  	outer_for:
  		#  for(i = 1; i < word1_len + 1; i++){
  		movl i(%ebp), %eax
  		cmpl strlen1(%ebp), %eax
  		jge outer_for_end
  		
  		movl i(%ebp), %eax
  		movl %eax, curDist 

 		movl $1, j(%ebp)  	
  		inner_for: 
  			movl j(%ebp), %eax
  			cmpl strlen2(%ebp), %eax 
  			jge inner_for_end
  			
  			inner_if: 
  				#if(word1[i-1] == word2[j-1]){
  			 	movl i(%ebp), %ebx
  			 	subl $1, %ebx
  				movb string1(,%ebx,cs), %al
  				
    			 	movl j(%ebp), %ebx
  			 	subl $1, %ebx

  			 	# word2[j-1]
  				cmpb %al, string2(,%ebx,cs) 
  				
  				jnz inner_else
  				
  				#curDist[j] = oldDist[j - 1]; 
  				movl j(%ebp), %ebx
  			 	subl $1, %ebx
  				movl oldDist(,%ebx,ws), %eax
  				

  				movl j(%ebp), %ebx
  				movl %eax, curDist(,%ebx,ws)
  				
  				jmp inner_else_end
  			inner_else:
  				movl j(%ebp), %ebx
  				movl oldDist(,%ebx,ws), %eax
  				movl j(%ebp), %ecx
  			 	subl $1, %ecx
  				movl curDist(,%ecx,ws), %ebx
  				call minimum
  				
  				movl min(%ebp), %eax
   				movl j(%ebp), %ecx
  			 	subl $1, %ecx
  				movl oldDist(,%ecx,ws), %ebx
  				call minimum
  				movl min(%ebp), %eax
  				addl $1, %eax
  				movl j(%ebp), %ecx
  				movl %eax, curDist(,%ecx,ws)
  			
  			inner_else_end:
  			
  			movl j(%ebp), %eax
  			inc %eax
  			movl %eax, j(%ebp)
  			  			
  			jmp inner_for
  			
  		inner_for_end:
  		
  
  		call swap
  		

  		movl i(%ebp), %eax
  		inc %eax
  		movl %eax, i(%ebp)
  		
  		jmp outer_for
  		
  	outer_for_end:

	movl strlen2(%ebp), %ebx
	subl $1, %ebx
	movl oldDist(,%ebx,ws),%eax
	
	epilogue:
		pop %esi
		pop %ebx
		movl %ebp, %esp
		pop %ebp
		
	jmp done

# void swap
swap:  
  	movl $0, %ecx
	for_swap:
  		movl oldDist(,%ecx,ws),%eax
 		movl curDist(,%ecx,ws),%ebx
    		cmpl %eax, %ebx
    		jz check
    		movl %eax, temp
   		movl %ebx, %eax
   		movl temp, %ebx
     		movl %eax, oldDist(,%ecx,ws)
   		movl %ebx, curDist(,%ecx,ws)
   	
   	equal:
    		inc %ecx
		jmp for_swap
    
  	check:
  		movb $0x0, %dl 
  		cmp %dl, %al
   		jnz equal
   		ret
		
# int minimum
minimum:
	
	if:
		cmpl %eax, %ebx
	 	jge else 
	 	
	 	movl %ebx, min(%ebp)
	 	ret
	else: 
		movl %eax, min(%ebp)
		ret
		
# int stringLen		
stringLen:
	movl $0, %eax
	ifstringlen:
		cmpl $1, buf
		jz str1len
		jmp str2len

	str1len:
		cmpb $0, string1(%eax)
		jz while_end_str1
		incl %eax
		jmp str1len

	while_end_str1:
		movl %eax, strlen1(%ebp)
		ret

	str2len:
		cmpb $0, string2(%eax)
		jz while_end_str2
		incl %eax
		jmp str2len

	while_end_str2:
		movl %eax, strlen2(%ebp)
		ret

done:
	nop
