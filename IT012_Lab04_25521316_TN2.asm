# Ho ten  : Nguyen Le Quoc Nhat
# MSSV    : 25521316
# Muc dich: Doc dien nang (kWh) tu ban phim, xac dinh bac gia dien (1..4) va in ra 
# Ke hoach dung thanh ghi:
#   $s0 = dien nang nhap vao (kWh)    $s1 = bac gia dien (1..4)
#   $t0 = ket qua slti (tam, dung de rem nhanh)

.data
prompt: .asciiz "Nhap dien nang (kWh): "
msg: .asciiz "Bac: "
nl: .asciiz "\n"

.text
.globl main
main:
    li   $v0, 4
    la   $a0, prompt
    syscall
    li   $v0, 5              # doc kWh, ket qua o $v0
    syscall
    add  $s0, $v0, $zero     # $s0 = dien nang (kWh)

    # xac dinh bac (1..4) theo Bang 6, dat vao $s1
    slti $t0, $s0, 101       # $t0 = 1 neu kWh <= 100
    bne  $t0, $zero, Bac1
    slti $t0, $s0, 151       # $t0 = 1 neu kWh <= 150
    bne  $t0, $zero, Bac2
    slti $t0, $s0, 201       # $t0 = 1 neu kWh <= 200
    bne  $t0, $zero, Bac3
    addi $s1, $zero, 4       # con lai: bac 4 (>= 201)
    j    Print
Bac1:
    addi $s1, $zero, 1
    j    Print
Bac2:
    addi $s1, $zero, 2
    j    Print
Bac3:
    addi $s1, $zero, 3

Print:
    # in "Bac: ", roi $s1, roi xuong dong
    li   $v0, 4
    la   $a0, msg
    syscall
    li   $v0, 1
    add  $a0, $s1, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall

    li   $v0, 10
    syscall
