
# qhasm: int64 input_0

# qhasm: int64 input_1

# qhasm: int64 input_2

# qhasm: int64 input_3

# qhasm: int64 input_4

# qhasm: int64 input_5

# qhasm: stack64 input_6

# qhasm: stack64 input_7

# qhasm: int64 caller_r11

# qhasm: int64 caller_r12

# qhasm: int64 caller_r13

# qhasm: int64 caller_r14

# qhasm: int64 caller_r15

# qhasm: int64 caller_rbx

# qhasm: int64 caller_rbp

# qhasm: int64 ctri

# qhasm: int64 ap

# qhasm: int64 cp

# qhasm: reg256 a

# qhasm: reg256 q

# qhasm: reg256 qinv

# qhasm: reg256 c

# qhasm: enter pwmul_double
.p2align 5
.global _pwmul_double
.global pwmul_double
_pwmul_double:
pwmul_double:
mov %rsp,%r11
and $31,%r11
add $0,%r11
sub %r11,%rsp

# qhasm: cp = input_0
# asm 1: mov  <input_0=int64#1,>cp=int64#1
# asm 2: mov  <input_0=%rdi,>cp=%rdi
mov  %rdi,%rdi

# qhasm: ap = input_1
# asm 1: mov  <input_1=int64#2,>ap=int64#2
# asm 2: mov  <input_1=%rsi,>ap=%rsi
mov  %rsi,%rsi

# qhasm: q = mem256[q8]
# asm 1: vmovdqu q8,>q=reg256#1
# asm 2: vmovdqu q8,>q=%ymm0
vmovdqu q8,%ymm0

# qhasm: qinv = mem256[qinv16]
# asm 1: vmovdqu qinv16,>qinv=reg256#2
# asm 2: vmovdqu qinv16,>qinv=%ymm1
vmovdqu qinv16,%ymm1

# qhasm: ctri = 256
# asm 1: mov  $256,>ctri=int64#3
# asm 2: mov  $256,>ctri=%rdx
mov  $256,%rdx

# qhasm: loopi:
._loopi:

# qhasm: c = (4x double)(4x int32)mem128[cp + 0]
# asm 1: vcvtdq2pd 0(<cp=int64#1),>c=reg256#3
# asm 2: vcvtdq2pd 0(<cp=%rdi),>c=%ymm2
vcvtdq2pd 0(%rdi),%ymm2

# qhasm: a = (4x double)(4x int32)mem128[ap + 0]
# asm 1: vcvtdq2pd 0(<ap=int64#2),>a=reg256#4
# asm 2: vcvtdq2pd 0(<ap=%rsi),>a=%ymm3
vcvtdq2pd 0(%rsi),%ymm3

# qhasm: 4x a approx*= c
# asm 1: vmulpd <c=reg256#3,<a=reg256#4,>a=reg256#3
# asm 2: vmulpd <c=%ymm2,<a=%ymm3,>a=%ymm2
vmulpd %ymm2,%ymm3,%ymm2

# qhasm: 4x c = approx a * qinv
# asm 1: vmulpd <a=reg256#3,<qinv=reg256#2,>c=reg256#4
# asm 2: vmulpd <a=%ymm2,<qinv=%ymm1,>c=%ymm3
vmulpd %ymm2,%ymm1,%ymm3

# qhasm: 4x c = floor(c)
# asm 1: vroundpd $9,<c=reg256#4,>c=reg256#4
# asm 2: vroundpd $9,<c=%ymm3,>c=%ymm3
vroundpd $9,%ymm3,%ymm3

# qhasm: 4x a approx-= c * q
# asm 1: vfnmadd231pd <c=reg256#4,<q=reg256#1,<a=reg256#3
# asm 2: vfnmadd231pd <c=%ymm3,<q=%ymm0,<a=%ymm2
vfnmadd231pd %ymm3,%ymm0,%ymm2

# qhasm: a = (4x int32)(4x double)a,0,0,0,0
# asm 1: vcvtpd2dq <a=reg256#3,>a=reg256#3dq
# asm 2: vcvtpd2dq <a=%ymm2,>a=%xmm2
vcvtpd2dq %ymm2,%xmm2

# qhasm: mem128[cp + 0] = a
# asm 1: movupd <a=reg256#3dq,0(<cp=int64#1)
# asm 2: movupd <a=%xmm2,0(<cp=%rdi)
movupd %xmm2,0(%rdi)

# qhasm: ap += 16
# asm 1: add  $16,<ap=int64#2
# asm 2: add  $16,<ap=%rsi
add  $16,%rsi

# qhasm: cp += 16
# asm 1: add  $16,<cp=int64#1
# asm 2: add  $16,<cp=%rdi
add  $16,%rdi

# qhasm: unsigned>? ctri -= 1
# asm 1: sub  $1,<ctri=int64#3
# asm 2: sub  $1,<ctri=%rdx
sub  $1,%rdx
# comment:fp stack unchanged by jump

# qhasm: goto loopi if unsigned>
ja ._loopi

# qhasm: return
add %r11,%rsp
ret
