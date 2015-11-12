
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

# qhasm: reg256 r

# qhasm: reg256 r2

# qhasm: reg256 a

# qhasm: reg256 b

# qhasm: reg256 t

# qhasm: reg256 l

# qhasm: reg256 h

# qhasm: reg256 zero

# qhasm: reg256 _mask1

# qhasm: reg256 _mask255

# qhasm: reg256 _q16x

# qhasm: int64 ctr

# qhasm: int64 r2p

# qhasm: enter cbd
.p2align 5
.global _cbd
.global cbd
_cbd:
cbd:
mov %rsp,%r11
and $31,%r11
add $0,%r11
sub %r11,%rsp

# qhasm: _mask1 = mem256[mask1]
# asm 1: vmovdqu mask1,>_mask1=reg256#1
# asm 2: vmovdqu mask1,>_mask1=%ymm0
vmovdqu mask1,%ymm0

# qhasm: _mask255 = mem256[mask255]
# asm 1: vmovdqu mask255,>_mask255=reg256#2
# asm 2: vmovdqu mask255,>_mask255=%ymm1
vmovdqu mask255,%ymm1

# qhasm: _q16x  = mem256[q16x]
# asm 1: vmovdqu q16x,>_q16x=reg256#3
# asm 2: vmovdqu q16x,>_q16x=%ymm2
vmovdqu q16x,%ymm2

# qhasm: r2p = input_1 + 2048
# asm 1: lea  2048(<input_1=int64#2),>r2p=int64#3
# asm 2: lea  2048(<input_1=%rsi),>r2p=%rdx
lea  2048(%rsi),%rdx

# qhasm: ctr = 32
# asm 1: mov  $32,>ctr=int64#4
# asm 2: mov  $32,>ctr=%rcx
mov  $32,%rcx

# qhasm: zero ^= zero
# asm 1: vpxor <zero=reg256#4,<zero=reg256#4,<zero=reg256#4
# asm 2: vpxor <zero=%ymm3,<zero=%ymm3,<zero=%ymm3
vpxor %ymm3,%ymm3,%ymm3

# qhasm: ulooptop:
._ulooptop:

# qhasm:   r  = mem256[input_1 + 0]
# asm 1: vmovupd   0(<input_1=int64#2),>r=reg256#5
# asm 2: vmovupd   0(<input_1=%rsi),>r=%ymm4
vmovupd   0(%rsi),%ymm4

# qhasm:   r2 = mem256[r2p     + 0]
# asm 1: vmovupd   0(<r2p=int64#3),>r2=reg256#6
# asm 2: vmovupd   0(<r2p=%rdx),>r2=%ymm5
vmovupd   0(%rdx),%ymm5

# qhasm:   a = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>a=reg256#7
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>a=%ymm6
vpand %ymm4,%ymm0,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#5
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm4
vpand %ymm4,%ymm0,%ymm4

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#5,<a=reg256#7,>a=reg256#5
# asm 2: vpaddb <t=%ymm4,<a=%ymm6,>a=%ymm4
vpaddb %ymm4,%ymm6,%ymm4

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#7
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm6
vpand %ymm5,%ymm0,%ymm6

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#7,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm6,<a=%ymm4,>a=%ymm4
vpaddb %ymm6,%ymm4,%ymm4

# qhasm:   16x r2 unsigned>>= 1
# asm 1: vpsrlw $1,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $1,<r2=%ymm5,>r2=%ymm5
vpsrlw $1,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#7
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm6
vpand %ymm5,%ymm0,%ymm6

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#7,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm6,<a=%ymm4,>a=%ymm4
vpaddb %ymm6,%ymm4,%ymm4

# qhasm:   16x r2 unsigned>>= 1
# asm 1: vpsrlw $1,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $1,<r2=%ymm5,>r2=%ymm5
vpsrlw $1,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#7
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm6
vpand %ymm5,%ymm0,%ymm6

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#7,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm6,<a=%ymm4,>a=%ymm4
vpaddb %ymm6,%ymm4,%ymm4

# qhasm:   16x r2 unsigned>>= 1
# asm 1: vpsrlw $1,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $1,<r2=%ymm5,>r2=%ymm5
vpsrlw $1,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#6
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm5
vpand %ymm5,%ymm0,%ymm5

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#6,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm5,<a=%ymm4,>a=%ymm4
vpaddb %ymm5,%ymm4,%ymm4

# qhasm:   16x b = a unsigned>> 8
# asm 1: vpsrlw $8,<a=reg256#5,>b=reg256#6
# asm 2: vpsrlw $8,<a=%ymm4,>b=%ymm5
vpsrlw $8,%ymm4,%ymm5

# qhasm:   a &= _mask255
# asm 1: vpand <_mask255=reg256#2,<a=reg256#5,<a=reg256#5
# asm 2: vpand <_mask255=%ymm1,<a=%ymm4,<a=%ymm4
vpand %ymm1,%ymm4,%ymm4

# qhasm:   16x a += _q16x
# asm 1: vpaddw <_q16x=reg256#3,<a=reg256#5,>a=reg256#5
# asm 2: vpaddw <_q16x=%ymm2,<a=%ymm4,>a=%ymm4
vpaddw %ymm2,%ymm4,%ymm4

# qhasm:   16x a -= b
# asm 1: vpsubw <b=reg256#6,<a=reg256#5,>a=reg256#5
# asm 2: vpsubw <b=%ymm5,<a=%ymm4,>a=%ymm4
vpsubw %ymm5,%ymm4,%ymm4

# qhasm:   l[0,1,2,3] = a[0,1],a[0,1]
# asm 1: vperm2f128 $0x20,<a=reg256#5,<a=reg256#5,>l=reg256#6
# asm 2: vperm2f128 $0x20,<a=%ymm4,<a=%ymm4,>l=%ymm5
vperm2f128 $0x20,%ymm4,%ymm4,%ymm5

# qhasm:   h[0,1,2,3] = a[2,3],a[2,3]
# asm 1: vperm2f128 $0x31,<a=reg256#5,<a=reg256#5,>h=reg256#5
# asm 2: vperm2f128 $0x31,<a=%ymm4,<a=%ymm4,>h=%ymm4
vperm2f128 $0x31,%ymm4,%ymm4,%ymm4

# qhasm:   l[0,1,2,3] = l[0,0,3,3]
# asm 1: vpermilpd $0xc,<l=reg256#6,>l=reg256#6
# asm 2: vpermilpd $0xc,<l=%ymm5,>l=%ymm5
vpermilpd $0xc,%ymm5,%ymm5

# qhasm:   l = l[0]zero[0]l[1]zero[1]l[2]zero[2]l[3]zero[3]l[8]zero[8]l[9]zero[9]l[10]zero[10]l[11]zero[11]
# asm 1: vpunpcklwd <zero=reg256#4,<l=reg256#6,>l=reg256#6
# asm 2: vpunpcklwd <zero=%ymm3,<l=%ymm5,>l=%ymm5
vpunpcklwd %ymm3,%ymm5,%ymm5

# qhasm:   h[0,1,2,3] = h[0,0,3,3]
# asm 1: vpermilpd $0xc,<h=reg256#5,>h=reg256#5
# asm 2: vpermilpd $0xc,<h=%ymm4,>h=%ymm4
vpermilpd $0xc,%ymm4,%ymm4

# qhasm:   h = h[0]zero[0]h[1]zero[1]h[2]zero[2]h[3]zero[3]h[8]zero[8]h[9]zero[9]h[10]zero[10]h[11]zero[11]
# asm 1: vpunpcklwd <zero=reg256#4,<h=reg256#5,>h=reg256#5
# asm 2: vpunpcklwd <zero=%ymm3,<h=%ymm4,>h=%ymm4
vpunpcklwd %ymm3,%ymm4,%ymm4

# qhasm:   mem256[input_0 +  0] = l
# asm 1: vmovupd   <l=reg256#6,0(<input_0=int64#1)
# asm 2: vmovupd   <l=%ymm5,0(<input_0=%rdi)
vmovupd   %ymm5,0(%rdi)

# qhasm:   mem256[input_0 + 32] = h
# asm 1: vmovupd   <h=reg256#5,32(<input_0=int64#1)
# asm 2: vmovupd   <h=%ymm4,32(<input_0=%rdi)
vmovupd   %ymm4,32(%rdi)

# qhasm:   input_0 += 64
# asm 1: add  $64,<input_0=int64#1
# asm 2: add  $64,<input_0=%rdi
add  $64,%rdi

# qhasm:   input_1 += 32
# asm 1: add  $32,<input_1=int64#2
# asm 2: add  $32,<input_1=%rsi
add  $32,%rsi

# qhasm:   r2p += 32
# asm 1: add  $32,<r2p=int64#3
# asm 2: add  $32,<r2p=%rdx
add  $32,%rdx

# qhasm:   unsigned>? ctr -= 1
# asm 1: sub  $1,<ctr=int64#4
# asm 2: sub  $1,<ctr=%rcx
sub  $1,%rcx
# comment:fp stack unchanged by jump

# qhasm: goto ulooptop if unsigned>
ja ._ulooptop

# qhasm: ctr = 32
# asm 1: mov  $32,>ctr=int64#4
# asm 2: mov  $32,>ctr=%rcx
mov  $32,%rcx

# qhasm: r2p -= 1024
# asm 1: sub  $1024,<r2p=int64#3
# asm 2: sub  $1024,<r2p=%rdx
sub  $1024,%rdx

# qhasm: llooptop:
._llooptop:

# qhasm:   r = mem256[input_1 +  0]
# asm 1: vmovupd   0(<input_1=int64#2),>r=reg256#5
# asm 2: vmovupd   0(<input_1=%rsi),>r=%ymm4
vmovupd   0(%rsi),%ymm4

# qhasm:   r2 = mem256[r2p     + 0]
# asm 1: vmovupd   0(<r2p=int64#3),>r2=reg256#6
# asm 2: vmovupd   0(<r2p=%rdx),>r2=%ymm5
vmovupd   0(%rdx),%ymm5

# qhasm:   a = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>a=reg256#7
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>a=%ymm6
vpand %ymm4,%ymm0,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#8
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm7
vpand %ymm4,%ymm0,%ymm7

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#8,<a=reg256#7,>a=reg256#7
# asm 2: vpaddb <t=%ymm7,<a=%ymm6,>a=%ymm6
vpaddb %ymm7,%ymm6,%ymm6

# qhasm:   16x r unsigned>>= 1
# asm 1: vpsrlw $1,<r=reg256#5,>r=reg256#5
# asm 2: vpsrlw $1,<r=%ymm4,>r=%ymm4
vpsrlw $1,%ymm4,%ymm4

# qhasm:   t = r & _mask1
# asm 1: vpand <r=reg256#5,<_mask1=reg256#1,>t=reg256#5
# asm 2: vpand <r=%ymm4,<_mask1=%ymm0,>t=%ymm4
vpand %ymm4,%ymm0,%ymm4

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#5,<a=reg256#7,>a=reg256#5
# asm 2: vpaddb <t=%ymm4,<a=%ymm6,>a=%ymm4
vpaddb %ymm4,%ymm6,%ymm4

# qhasm:   16x r2 unsigned>>= 4
# asm 1: vpsrlw $4,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $4,<r2=%ymm5,>r2=%ymm5
vpsrlw $4,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#7
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm6
vpand %ymm5,%ymm0,%ymm6

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#7,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm6,<a=%ymm4,>a=%ymm4
vpaddb %ymm6,%ymm4,%ymm4

# qhasm:   16x r2 unsigned>>= 1
# asm 1: vpsrlw $1,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $1,<r2=%ymm5,>r2=%ymm5
vpsrlw $1,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#7
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm6
vpand %ymm5,%ymm0,%ymm6

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#7,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm6,<a=%ymm4,>a=%ymm4
vpaddb %ymm6,%ymm4,%ymm4

# qhasm:   16x r2 unsigned>>= 1
# asm 1: vpsrlw $1,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $1,<r2=%ymm5,>r2=%ymm5
vpsrlw $1,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#7
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm6
vpand %ymm5,%ymm0,%ymm6

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#7,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm6,<a=%ymm4,>a=%ymm4
vpaddb %ymm6,%ymm4,%ymm4

# qhasm:   16x r2 unsigned>>= 1
# asm 1: vpsrlw $1,<r2=reg256#6,>r2=reg256#6
# asm 2: vpsrlw $1,<r2=%ymm5,>r2=%ymm5
vpsrlw $1,%ymm5,%ymm5

# qhasm:   t = r2 & _mask1
# asm 1: vpand <r2=reg256#6,<_mask1=reg256#1,>t=reg256#6
# asm 2: vpand <r2=%ymm5,<_mask1=%ymm0,>t=%ymm5
vpand %ymm5,%ymm0,%ymm5

# qhasm:   32x a += t
# asm 1: vpaddb <t=reg256#6,<a=reg256#5,>a=reg256#5
# asm 2: vpaddb <t=%ymm5,<a=%ymm4,>a=%ymm4
vpaddb %ymm5,%ymm4,%ymm4

# qhasm:   16x b = a unsigned>> 8
# asm 1: vpsrlw $8,<a=reg256#5,>b=reg256#6
# asm 2: vpsrlw $8,<a=%ymm4,>b=%ymm5
vpsrlw $8,%ymm4,%ymm5

# qhasm:   a &= _mask255
# asm 1: vpand <_mask255=reg256#2,<a=reg256#5,<a=reg256#5
# asm 2: vpand <_mask255=%ymm1,<a=%ymm4,<a=%ymm4
vpand %ymm1,%ymm4,%ymm4

# qhasm:   16x a += _q16x
# asm 1: vpaddw <_q16x=reg256#3,<a=reg256#5,>a=reg256#5
# asm 2: vpaddw <_q16x=%ymm2,<a=%ymm4,>a=%ymm4
vpaddw %ymm2,%ymm4,%ymm4

# qhasm:   16x a -= b
# asm 1: vpsubw <b=reg256#6,<a=reg256#5,>a=reg256#5
# asm 2: vpsubw <b=%ymm5,<a=%ymm4,>a=%ymm4
vpsubw %ymm5,%ymm4,%ymm4

# qhasm:   l[0,1,2,3] = a[0,1],a[0,1]
# asm 1: vperm2f128 $0x20,<a=reg256#5,<a=reg256#5,>l=reg256#6
# asm 2: vperm2f128 $0x20,<a=%ymm4,<a=%ymm4,>l=%ymm5
vperm2f128 $0x20,%ymm4,%ymm4,%ymm5

# qhasm:   h[0,1,2,3] = a[2,3],a[2,3]
# asm 1: vperm2f128 $0x31,<a=reg256#5,<a=reg256#5,>h=reg256#5
# asm 2: vperm2f128 $0x31,<a=%ymm4,<a=%ymm4,>h=%ymm4
vperm2f128 $0x31,%ymm4,%ymm4,%ymm4

# qhasm:   l[0,1,2,3] = l[0,0,3,3]
# asm 1: vpermilpd $0xc,<l=reg256#6,>l=reg256#6
# asm 2: vpermilpd $0xc,<l=%ymm5,>l=%ymm5
vpermilpd $0xc,%ymm5,%ymm5

# qhasm:   l = l[0]zero[0]l[1]zero[1]l[2]zero[2]l[3]zero[3]l[8]zero[8]l[9]zero[9]l[10]zero[10]l[11]zero[11]
# asm 1: vpunpcklwd <zero=reg256#4,<l=reg256#6,>l=reg256#6
# asm 2: vpunpcklwd <zero=%ymm3,<l=%ymm5,>l=%ymm5
vpunpcklwd %ymm3,%ymm5,%ymm5

# qhasm:   h[0,1,2,3] = h[0,0,3,3]
# asm 1: vpermilpd $0xc,<h=reg256#5,>h=reg256#5
# asm 2: vpermilpd $0xc,<h=%ymm4,>h=%ymm4
vpermilpd $0xc,%ymm4,%ymm4

# qhasm:   h = h[0]zero[0]h[1]zero[1]h[2]zero[2]h[3]zero[3]h[8]zero[8]h[9]zero[9]h[10]zero[10]h[11]zero[11]
# asm 1: vpunpcklwd <zero=reg256#4,<h=reg256#5,>h=reg256#5
# asm 2: vpunpcklwd <zero=%ymm3,<h=%ymm4,>h=%ymm4
vpunpcklwd %ymm3,%ymm4,%ymm4

# qhasm:   mem256[input_0 + 0] = l
# asm 1: vmovupd   <l=reg256#6,0(<input_0=int64#1)
# asm 2: vmovupd   <l=%ymm5,0(<input_0=%rdi)
vmovupd   %ymm5,0(%rdi)

# qhasm:   mem256[input_0 + 32] = h
# asm 1: vmovupd   <h=reg256#5,32(<input_0=int64#1)
# asm 2: vmovupd   <h=%ymm4,32(<input_0=%rdi)
vmovupd   %ymm4,32(%rdi)

# qhasm:   input_0 += 64
# asm 1: add  $64,<input_0=int64#1
# asm 2: add  $64,<input_0=%rdi
add  $64,%rdi

# qhasm:   input_1 += 32
# asm 1: add  $32,<input_1=int64#2
# asm 2: add  $32,<input_1=%rsi
add  $32,%rsi

# qhasm:   r2p += 32
# asm 1: add  $32,<r2p=int64#3
# asm 2: add  $32,<r2p=%rdx
add  $32,%rdx

# qhasm:   unsigned>? ctr -= 1
# asm 1: sub  $1,<ctr=int64#4
# asm 2: sub  $1,<ctr=%rcx
sub  $1,%rcx
# comment:fp stack unchanged by jump

# qhasm:   goto llooptop if unsigned>
ja ._llooptop

# qhasm: return
add %r11,%rsp
ret
