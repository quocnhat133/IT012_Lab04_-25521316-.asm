# Ho ten  : Nguyen Le Quoc Nhat
# MSSV    : 25521316
# Muc dich: Dem so thang theo bac gia dien bang mang cnt 
# Ke hoach dung thanh ghi:
#   $s0 = dia chi nen reading   $s1 = dia chi nen usage   $s2 = i   $s3 = n (12 thang)   $s4 = dia chi nen cnt
#   $t1 = dia chi reading[i] / usage[i]   $t3 = reading[i]   $t4 = reading[i+1]   $t5 = usage[i] (kWh)
#   $t0 = ket qua slti   $t2 = bac - 1 (chi so trong cnt)   $t6 = dia chi cnt[k]   $t7 = cnt[k]

.data
m1: .asciiz "Bac "
m2: .asciiz ": "
nl: .asciiz "\n"
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
.word 2210, 2440, 2625, 2775, 2895, 2995
usage: .space 48
cnt: .word 0, 0, 0, 0

.text
.globl main
main:
    la   $s0, reading
    la   $s1, usage
    la   $s4, cnt
    addi $s2, $zero, 0           # i = 0
    addi $s3, $zero, 12          # n = 12

# Vong 1: tinh usage[i] = reading[i+1] - reading[i] 
Loop1:
    beq  $s2, $s3, Pass2
    sll  $t1, $s2, 2
    add  $t1, $t1, $s0           # dia chi reading[i]
    lw   $t3, 0($t1)
    lw   $t4, 4($t1)
    sub  $t5, $t4, $t3
    sll  $t1, $s2, 2
    add  $t1, $t1, $s1           # dia chi usage[i]
    sw   $t5, 0($t1)
    addi $s2, $s2, 1
    j    Loop1

# Vong 2: duyet usage, xac dinh bac, tang cnt[bac-1] 
Pass2:
    addi $s2, $zero, 0           # i = 0
Loop2:
    beq  $s2, $s3, Print
    sll  $t1, $s2, 2
    add  $t1, $t1, $s1
    lw   $t5, 0($t1)             # $t5 = usage[i]
    slti $t0, $t5, 101           # bac 1: <= 100
    bne  $t0, $zero, T1
    slti $t0, $t5, 151           # bac 2: <= 150
    bne  $t0, $zero, T2
    slti $t0, $t5, 201           # bac 3: <= 200
    bne  $t0, $zero, T3
    addi $t2, $zero, 3           # bac 4 -> chi so 3
    j    Inc
T1: addi $t2, $zero, 0
    j    Inc
T2: addi $t2, $zero, 1
    j    Inc
T3: addi $t2, $zero, 2
Inc:
    sll  $t6, $t2, 2
    add  $t6, $t6, $s4           # dia chi cnt[k]
    lw   $t7, 0($t6)
    addi $t7, $t7, 1
    sw   $t7, 0($t6)
    addi $s2, $s2, 1
    j    Loop2

# In bon dong: Bac <k>: <so thang> 
Print:
    addi $s2, $zero, 0           # k = 0
    addi $s3, $zero, 4
Loop3:
    beq  $s2, $s3, Exit
    li   $v0, 4
    la   $a0, m1
    syscall
    li   $v0, 1
    addi $a0, $s2, 1
    syscall
    li   $v0, 4
    la   $a0, m2
    syscall
    sll  $t6, $s2, 2
    add  $t6, $t6, $s4
    lw   $a0, 0($t6)
    li   $v0, 1
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    addi $s2, $s2, 1
    j    Loop3
Exit:
    li   $v0, 10
    syscall
