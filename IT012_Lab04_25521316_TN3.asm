# Ho ten  : Nguyen Le Quoc Nhat
# MSSV    : 25521316
# Muc dich: Dien nang tung thang, tong dien nang va thang tieu thu nhieu nhat 
# Ke hoach dung thanh ghi:
#   $s0 = dia chi nen reading   $s1 = dia chi nen usage   $s2 = i   $s3 = n (12 thang)
#   $s4 = tong dien nang   $s5 = dien nang lon nhat   $s6 = thang cua dien nang lon nhat
#   $t1 = dia chi reading[i]   $t3 = reading[i]   $t4 = reading[i+1]   $t5 = dien nang thang i+1
#   $t6 = dia chi usage[i]   $t7 = ket qua slt

.data
m1: .asciiz "Thang "
m2: .asciiz ": "
mt: .asciiz "Tong: "
mm: .asciiz "Thang cao nhat: "
lp: .asciiz " ("
rp: .asciiz ")"
nl: .asciiz "\n"
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
.word 2210, 2440, 2625, 2775, 2895, 2995
usage: .space 48

.text
.globl main
main:
    la   $s0, reading        # $s0 = dia chi nen reading
    la   $s1, usage          # $s1 = dia chi nen usage
    addi $s2, $zero, 0       # i = 0
    addi $s3, $zero, 12      # n = 12 thang
    addi $s4, $zero, 0       # tong = 0
    addi $s5, $zero, 0       # max = 0
    addi $s6, $zero, 0       # thang max = 0
Loop:
    beq  $s2, $s3, Done      # thoat neu i == n
    sll  $t1, $s2, 2         # $t1 = 4 * i
    add  $t1, $t1, $s0       # $t1 = dia chi reading[i]
    lw   $t3, 0($t1)         # $t3 = reading[i]
    lw   $t4, 4($t1)         # $t4 = reading[i+1]
    sub  $t5, $t4, $t3       # $t5 = dien nang thang i+1
    sll  $t6, $s2, 2         # $t6 = 4 * i
    add  $t6, $t6, $s1       # $t6 = dia chi usage[i]
    sw   $t5, 0($t6)         # usage[i] = $t5
    add  $s4, $s4, $t5       # tong += dien nang
    slt  $t7, $s5, $t5       # $t7 = 1 neu max < dien nang thang nay
    beq  $t7, $zero, Skip
    add  $s5, $t5, $zero     # max = dien nang
    addi $s6, $s2, 1         # thang cua max = i + 1
Skip:
    li   $v0, 4
    la   $a0, m1
    syscall
    li   $v0, 1
    addi $a0, $s2, 1
    syscall
    li   $v0, 4
    la   $a0, m2
    syscall
    li   $v0, 1
    add  $a0, $t5, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    addi $s2, $s2, 1         # i = i + 1
    j    Loop
Done:
    li   $v0, 4
    la   $a0, mt
    syscall
    li   $v0, 1
    add  $a0, $s4, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    li   $v0, 4
    la   $a0, mm
    syscall
    li   $v0, 1
    add  $a0, $s6, $zero
    syscall
    li   $v0, 4
    la   $a0, lp
    syscall
    li   $v0, 1
    add  $a0, $s5, $zero
    syscall
    li   $v0, 4
    la   $a0, rp
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    li   $v0, 10
    syscall
