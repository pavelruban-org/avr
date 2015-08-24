	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.global	main_init
	.type	main_init, @function
main_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(term_var_info_array)
	ldi r25,hi8(term_var_info_array)
	sts term_var_info+1,r25
	sts term_var_info,r24
	rcall spi_init
	sbi 0xb,4
	sbi 0x5,1
	ldi r30,lo8(mac_addr)
	ldi r31,hi8(mac_addr)
	st Z,__zero_reg__
	ldi r24,lo8(19)
	std Z+1,r24
	ldi r24,lo8(55)
	std Z+2,r24
	ldi r24,lo8(1)
	std Z+3,r24
	ldi r24,lo8(35)
	std Z+4,r24
	ldi r24,lo8(69)
	std Z+5,r24
	ldi r24,lo8(-64)
	ldi r25,lo8(-88)
	ldi r26,0
	ldi r27,lo8(11)
	sts ip_addr,r24
	sts ip_addr+1,r25
	sts ip_addr+2,r26
	sts ip_addr+3,r27
	ldi r24,lo8(-1)
	ldi r25,lo8(-1)
	ldi r26,lo8(-1)
	ldi r27,0
	sts ip_mask,r24
	sts ip_mask+1,r25
	sts ip_mask+2,r26
	sts ip_mask+3,r27
	ldi r24,lo8(-64)
	ldi r25,lo8(-88)
	ldi r26,0
	ldi r27,lo8(1)
	sts ip_gateway,r24
	sts ip_gateway+1,r25
	sts ip_gateway+2,r26
	sts ip_gateway+3,r27
	rcall lan_init
	rcall mfrc522_init
	lds r30,term_var_info
	lds r31,term_var_info+1
	ldi r24,lo8(111)
	st Z,r24
	lds r30,term_var_info
	lds r31,term_var_info+1
	ldi r24,lo8(107)
	std Z+1,r24
	lds r30,term_var_info
	lds r31,term_var_info+1
	ldi r18,lo8(10)
	std Z+2,r18
	ldi r25,lo8(13)
	std Z+3,r25
	ldi r24,lo8(45)
	std Z+4,r24
	std Z+5,r24
	std Z+6,r24
	std Z+7,r18
	std Z+8,r25
	std Z+9,__zero_reg__
	ldi r24,lo8(5)
	ldi r25,0
	sts delta+1,r25
	sts delta,r24
	ret
	.size	main_init, .-main_init
.global	end_signal
	.type	end_signal, @function
end_signal:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0xb,6
	ret
	.size	end_signal, .-end_signal
.global	door_delay
	.type	door_delay, @function
door_delay:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r18,lo8(351999)
	ldi r24,hi8(351999)
	ldi r25,hlo8(351999)
	1: subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	ret
	.size	door_delay, .-door_delay
.global	ok_signal
	.type	ok_signal, @function
ok_signal:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	ldi r17,lo8(3)
	ldi r29,0
	ldi r28,0
	ldi r16,0
	ldi r30,lo8(64)
	mov r19,r16
	ldi r27,lo8(30)
	mov r26,r29
	mov r31,r28
	rjmp .L5
.L7:
	mov r24,r18
	ldi r25,0
	lds r22,delta
	lds r23,delta+1
	cp r24,r22
	cpc r25,r23
	brne .L6
	in r24,0xb
	eor r24,r30
	out 0xb,r24
	mov r18,r19
.L6:
	subi r18,lo8(-(1))
	subi r20,-1
	sbci r21,-1
	cpi r20,82
	ldi r24,3
	cpc r21,r24
	brne .L7
	mov r18,r27
.L9:
	cbi 0xb,6
	mov r24,r26
	mov r25,r31
.L8:
	adiw r24,1
	cpi r24,50
	cpc r25,__zero_reg__
	brne .L8
	subi r18,lo8(-(-1))
	brne .L9
	mov r24,r29
	mov r25,r28
.L10:
	adiw r24,1
	cpi r24,-114
	ldi r18,68
	cpc r25,r18
	brne .L10
	subi r17,lo8(-(-1))
	breq .L4
.L5:
	mov r20,r29
	mov r21,r28
	mov r18,r16
	rjmp .L7
.L4:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	ok_signal, .-ok_signal
.global	open_door
	.type	open_door, @function
open_door:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0x8,5
	ret
	.size	open_door, .-open_door
.global	close_door
	.type	close_door, @function
close_door:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x8,5
	ret
	.size	close_door, .-close_door
.global	open_door_script
	.type	open_door_script, @function
open_door_script:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x8,1
	rcall open_door
	rcall ok_signal
	ldi r18,lo8(351999)
	ldi r24,hi8(351999)
	ldi r25,hlo8(351999)
	1: subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	ret
	.size	open_door_script, .-open_door_script
.global	close_door_script
	.type	close_door_script, @function
close_door_script:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0x8,1
	rcall close_door
	rcall end_signal
	ret
	.size	close_door_script, .-close_door_script
.global	udp_packet
	.type	udp_packet, @function
udp_packet:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	adiw r24,42
	sbi 0x8,2
	ldd r18,Y+42
	cpi r18,lo8(99)
	brne .L21
	ldd r18,Y+43
	cpi r18,lo8(111)
	brne .L21
	ldd r18,Y+44
	cpi r18,lo8(109)
	brne .L21
	ldd r18,Y+45
	cpi r18,lo8(109)
	brne .L21
	ldd r18,Y+46
	cpi r18,lo8(97)
	brne .L21
	ldd r18,Y+47
	cpi r18,lo8(110)
	brne .L21
	ldd r18,Y+48
	cpi r18,lo8(100)
	brne .L21
	ldd r18,Y+49
	cpi r18,lo8(58)
	brne .L21
	ldd r18,Y+50
	cpi r18,lo8(32)
	brne .L21
	ldd r18,Y+51
	cpi r18,lo8(111)
	brne .L21
	ldd r18,Y+52
	cpi r18,lo8(112)
	brne .L21
	ldd r18,Y+53
	cpi r18,lo8(101)
	brne .L21
	ldd r18,Y+54
	cpi r18,lo8(110)
	brne .L21
	ldi r22,lo8(1)
	rcall fill_net_buff
	ldi r22,lo8(2)
	ldi r23,0
	movw r24,r28
	rcall udp_reply
	rcall open_door_script
	rcall close_door_script
	rjmp .L20
.L21:
	ldi r22,lo8(2)
	rcall fill_net_buff
	ldi r22,lo8(7)
	ldi r23,0
	movw r24,r28
	rcall udp_reply
.L20:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	udp_packet, .-udp_packet
.global	rfid
	.type	rfid, @function
rfid:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(str)
	ldi r23,hi8(str)
	ldi r24,lo8(82)
	rcall mfrc522_request
	sts byte,r24
	cpi r24,lo8(1)
	breq .+2
	rjmp .L24
	ldi r24,lo8(str)
	ldi r25,hi8(str)
	rcall mfrc522_get_card_serial
	sts byte,r24
	cpi r24,lo8(1)
	breq .+2
	rjmp .L25
	ldi r30,lo8(net_buf)
	ldi r31,hi8(net_buf)
	ldi r24,lo8(8)
	ldi r25,0
	std Z+13,r25
	std Z+12,r24
	std Z+6,__zero_reg__
	ldi r24,lo8(-32)
	std Z+7,r24
	ldi r24,lo8(65)
	std Z+8,r24
	ldi r24,lo8(34)
	std Z+9,r24
	ldi r24,lo8(10)
	std Z+10,r24
	ldi r24,lo8(-18)
	std Z+11,r24
	ldi r24,lo8(101)
	ldi r25,lo8(-12)
	std Z+35,r25
	std Z+34,r24
	std Z+37,r25
	std Z+36,r24
	ldi r24,lo8(-64)
	ldi r25,lo8(-88)
	ldi r26,0
	ldi r27,lo8(47)
	std Z+26,r24
	std Z+27,r25
	std Z+28,r26
	std Z+29,r27
	ldi r24,lo8(17)
	std Z+23,r24
	ldi r24,lo8(99)
	std Z+42,r24
	ldi r24,lo8(97)
	std Z+43,r24
	ldi r24,lo8(114)
	std Z+44,r24
	ldi r24,lo8(100)
	std Z+45,r24
	ldi r24,lo8(58)
	std Z+46,r24
	ldi r24,lo8(32)
	std Z+47,r24
	sts byte,__zero_reg__
	ldi r24,0
.L26:
	ldi r25,0
	movw r30,r24
	subi r30,lo8(-(net_buf+14))
	sbci r31,hi8(-(net_buf+14))
	movw r26,r24
	subi r26,lo8(-(str))
	sbci r27,hi8(-(str))
	ld r18,X
	std Z+34,r18
	lds r20,term_var_info
	lds r21,term_var_info+1
	movw r30,r20
	add r30,r24
	adc r31,r25
	st Z,r18
	lds r24,byte
	subi r24,lo8(-(1))
	sts byte,r24
	cpi r24,lo8(5)
	brlo .L26
	ldi r22,lo8(11)
	ldi r23,0
	ldi r24,lo8(net_buf)
	ldi r25,hi8(net_buf)
	rcall udp_reply
	lds r24,byte
	lds r30,term_var_info
	lds r31,term_var_info+1
	add r30,r24
	adc r31,__zero_reg__
	st Z,__zero_reg__
	rcall open_door_script
	rcall close_door_script
	ret
.L25:
	lds r30,term_var_info
	lds r31,term_var_info+1
	std Z+9,__zero_reg__
	ret
.L24:
	lds r30,term_var_info
	lds r31,term_var_info+1
	std Z+9,__zero_reg__
	ret
	.size	rfid, .-rfid
	.comm	delta,2,1
	.comm	str,16,1
	.comm	byte,1,1
	.comm	term_var_info_array,20,1
	.comm	term_var_info,2,1
	.ident	"GCC: (GNU) 4.9.2 20141224 (prerelease)"
.global __do_clear_bss
