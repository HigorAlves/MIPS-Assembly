.globl main
.data
  msgprompt: .word msgprompt_data
  msgres1: .word msgres1_data
  msgres2: .word msgres2_data

  msgprompt_data: .asciiz "Entre com um valor positivo: "
  msgres1_data: .asciiz "O fatorial de "
  msgres2_data: .asciiz " � "


.text
main:
  # Escrevendo no prompt
  #printf("Entre com um valor positivo: ");
  la      $t0, msgprompt    # load o endere�o msgprompt dentro de $t0
  lw      $a0, 0($t0)       # load data do endere�o em $t0 dentro de $a0
  li      $v0, 4            # chama o codigo para print_string
  syscall                   # executa print_string syscall

  # reading the input int
  # scanf("%d", &number);
  li      $v0, 5            # call code for read_int
  syscall                   # run the read_int syscall
  move    $t0, $v0          # store input in $t0

  move    $a0, $t0          # move input to argument register $a0
  addi    $sp, $sp, -12     # move stackpointer up 3 words
  sw      $t0, 0($sp)       # store input in top of stack
  sw      $ra, 8($sp)       # store counter at bottom of stack
  jal     factorial         # call factorial

  # when we get here, we have the final return value in 4($sp)

  lw      $s0, 4($sp)       # load final return val into $s0

  # printf("The value of 'factorial(%d)' is:  %d\n",
  la      $t1, msgres1      # load msgres1 address into $t1
  lw      $a0, 0($t1)       # load msgres1_data value into $a0
  li      $v0, 4            # system call for print_string
  syscall                   # print value of msgres1_data to screen

  lw      $a0, 0($sp)       # load original value into $a0
  li      $v0, 1            # system call for print_int
  syscall                   # print original value to screen

  la      $t2, msgres2      #load msgres2 address into $t1
  lw      $a0, 0($t2)       # load msgres_data value into $a0
  li      $v0, 4            # system call for print_string
  syscall                   # print value of msgres2_data to screen

  move    $a0, $s0          # move final return value from $s0 to $a0 for return
  li      $v0, 1            # system call for print_int
  syscall                   # print final return value to screen

  addi    $sp, $sp, 12      # move stack pointer back down where we started

  # return 0;
  li      $v0, 10           # system call for exit
  syscall                   # exit!



.text
factorial:
  # base  case - still in parent's stack segment
  lw      $t0, 0($sp)       # load input from top of stack into register $t0
  #if (x == 0)
  beq     $t0, 0, returnOne # if $t0 is equal to 0, branch to returnOne
  addi    $t0, $t0, -1      # subtract 1 from $t0 if not equal to 0

  # recursive case - move to this call's stack segment
  addi    $sp, $sp, -12     # move stack pointer up 3 words
  sw      $t0, 0($sp)       # store current working number into the top of the stack segment
  sw      $ra, 8($sp)       # store counter at bottom of stack segment

  jal     factorial         # recursive call

  # if we get here, then we have the child return value in 4($sp)
  lw      $ra, 8($sp)       # load this call's $ra again(we just got back from a jump)
  lw      $t1, 4($sp)       # load child's return value into $t1

  lw      $t2, 12($sp)      # load parent's start value into $t2
# return x * factorial(x-1); (not the return statement, but the multiplication)
  mul     $t3, $t1, $t2     # multiply child's return value by parent's working value, store in $t3.

  sw      $t3, 16($sp)      # take result(in $t3), store in parent's return value.

  addi    $sp, $sp, 12      # move stackpointer back down for the parent call

  jr      $ra               # jump to parent call

.text
#return 1;
returnOne:
  li      $t0, 1            # load 1 into register $t0
  sw      $t0, 4($sp)       # store 1 into the parent's return value register
  jr $ra               # jump to parent call
