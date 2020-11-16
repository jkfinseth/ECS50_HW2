.data
num1:
        .long 420
        .long 69
num2:
        .long 404
        .long 100

.text
.global start_

start_:
# Upper 32 bits end up in EDX
# Lower 32 bits end up in EAX
        # Move 2nd half of num1 into eax
        movl num1+4, %eax
        # Add 2nd half of num2 into eax
        addl num2+4, %eax

        # Move first half of num1 into edx
        movl num1, %edx
        # Add 1st half of num2 into edx
        addl num2, %edx

        # Check if carry occured, go to finish if no jump occured
        jnc finish

        # Apply the carry and jump to finish
        addl $1, %edx   #since there's carry, add 1
        jmp finish

finish:
        # Reset the carry flag
        movl %eax, %eax
    
