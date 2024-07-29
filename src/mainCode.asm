.model small
.stack 0100h
.data

	linerow dw ?
	linecol dw ?
	linelength dw ?

	rectanglerow dw ?
	rectanglecol dw ?
	rectangle_h dw ?
	rectangle_b dw ?

	gamename_str db "CANDY CRUSH$"
	playgame_str db "PLAY GAME$"
	instructions_str db "INSTRUCTIONS$"
	entername_str db "Please Enter Your Name$"
	enter_start_str db "Press Enter If You Are Ready$"
	welcome db "Welcome $"
	line db "__________________$"
	namebuffer db 20 dup ("$")

	score2 db 3 dup ("$") 

	;SCORE STRING--------------//
	scoreStr db "SCORE:$"
	emptyStr db "  $"

	;LEVELSCOPE
	;SCORE STRING--------------//
	score dw 0
	counter db 0


	;-------Instructions page-----
	instructions_str1 db "Select candies with$"
	instructions_str11 db "up, down, left, right keys$"
	instructions_str2 db "Press Enter to swap candies$"
	instructions_str3 db "Player will get 15 moves$"
	instructions_str4 db "Get 100 point to finish a Level$"

	page1_counter db 1


	loop_count dw ?

	candy1_col dw ?
	candy1_row dw ?
	candy1_color db ?

	loop_count2 dw ?

	candy2_col dw ?
	candy2_row dw ?
	blue_color db 1
	white_color db 15

	board dw 2,2,4,4,2,6,3
		  dw 4,5,6,3,5,1,2
		  dw 2,2,5,3,6,2,5
		  dw 6,3,3,4,3,6,5
		  dw 5,1,5,2,1,5,1
		  dw 4,2,1,3,6,2,5
		  dw 6,4,4,2,7,1,3

	index_x dw ?
	index_y dw ?
	rows dw ?
	cols dw ?
	retainvalue dw ?

	to_multiply1 dw 2
	to_multiply2 dw 14



	;//choosing candies
	enter_counter dw 0			;initially set to 0 as no candy selected
	count_col dw 0
	count_row dw 0

	choice1 dw ?
	choice1_col dw ?
	choice1_row dw ?
	
	choice2 dw ?
	choice2_col dw ?
	choice2_row dw ?

	choice_check dw 0



	start1 dw ?
	start2 dw ?
	start3 dw ?

	end1 dw ?
	end2 dw ?

	adding dw ?

	max_rows dw 7
	max_cols dw 7
	current_element dw ?
	consecutive_count dw ?
	candy_value dw ?
	swap_check dw ?

	temp_candy dw ?

	i dw ?
	ib dw ?
	j dw ?
	none_zero_index dw ?
	zero_count dw ?
	non_zero_count dw ?
	zero_index dw ?
	new_position dw ?
	new_value dw ?

	status_value dw ?

	seed dw 0
	random dw 0


	;-----bomb variables-----\\
	bomb_check dw 0
	not_bomb dw ?

	;-----Delay Time-----\\
	delaytime dw 1

	;------Disapear Combos------\\
	col_number dw 0
	row_number dw 0

	;-------number of moves allowed-----------\\
	move_count dw 5
	move_number dw 0
	moves_str db "Moves:$"

	;-------levels functionality--------\\
	level dw 1

	;-----GAAME OVER PAGE-----------\\
	game_over db "....G.A.M.E...O.V.E.R....$"

.code
mov ax, @data
mov ds, ax
mov ax, 0


main proc

	;////////////////////////
	;call play_game

	call screen1

	mov ah,0
	mov al,13h		;videomode configuration 200 x 320
	int 10h

	call screen2

	mov ah, 4ch
	int 21h
	ret
Main Endp

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								make screen 1
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
screen1 proc
	mov ah,0
	mov al,13h
	int 10h

	;draw line
	mov bl, 4				;line color
	mov linerow, 45			;initial row
	mov linecol, 112		;initial col
	mov linelength, 100		;length of line
	call drawline1          ;calling function


	;---print string---
	;set curser
	mov dh, 4			;row
	mov dl, 15			;col
	mov ah, 2			;setcursor keyword
	int 10h

	;print string
	mov dx, offset gamename_str
	mov ah,09h
	int 21h


	;---print string---
	;set curser
	mov dh, 191			;row
	mov dl, 186			;col
	mov ah, 2			;setcursor keyword
	int 10h

	;print string
	mov dx, offset entername_str
	mov ah,09h
	int 21h


    ;draw line
	mov bl, 14				;line color
	mov linerow, 109		;initial row
	mov linecol, 200		;initial col
	mov linelength, 100		;length of line
	call drawline1          ;calling function


	;---print string---
	;set curser
	mov dh, 198			;row
	mov dl, 150			;col
	mov ah, 2			;setcursor keyword
	int 10h

	;print string
	mov dx, offset enter_start_str
	mov ah,09h
	int 21h

	
    ;draw line
	mov bl, 4				;line color
	mov linerow, 166		;initial row
	mov linecol, 110		;initial col
	mov linelength, 100		;length of line
	call drawline1          ;calling function



	;---get string---
	;set curser
	mov dh, 12			;row
	mov dl, 25			;col
	mov ah, 2			;setcursor keyword
	int 10h

	mov si, offset namebuffer
		getnameloop:
			mov ah,1
			int 16h
			jnz keychoice
			jz getnameloop

			keychoice:
				mov ah,0
				int 16h
				cmp al,13
				je leavegamename
				mov [si],al
				inc si
				mov dl, al
				mov ah,2
				int 21h
				jmp getnameloop

		leavegamename:

ret
screen1 endp
;								make screen 1
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								make screen 2
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
screen2 proc
	
	mov ah,0
	mov al,13h
	int 10h

	mov bl, 4				;color red rectangle
	mov rectanglerow, 90	;starting row
	mov rectanglecol, 107	;starting col
	mov rectangle_h, 19		;starting col
	mov rectangle_b, 114	;starting col
	call rectangle

	mov bl, 14				;color yellow rectangle
	mov rectanglerow, 145	;starting row
	mov rectanglecol, 107	;starting col
	call rectangle


	;draw line
	mov bl, 4				;line color
	mov linerow, 45			;initial row
	mov linecol, 113		;initial col
	mov linelength, 100		;length of line
	call drawline1          ;calling function

	mov score2,128

	;---print string---WELCOME 
	;set curser
	mov dh, 7			;row
	mov dl, 14			;col
	mov ah, 2			;setcursor keyword
	int 10h
	;print string
	mov dx, offset welcome
	mov ah,09h
	int 21h

	;---print string---WELCOME Name
	;set curser
	mov dh, 7			;row
	mov dl, 22			;col
	mov ah, 2			;setcursor keyword
	int 10h
	;print string
	mov dx, offset namebuffer
	mov ah,09h
	int 21h

	;---print string---Line
	;set curser
	mov dh, 8			;row
	mov dl, 11			;col
	mov ah, 2			;setcursor keyword
	mov al, 4
	int 10h
	;print string
	mov dx, offset line
	mov ah,09h
	int 21h	

	;---print string---GAME NAME
	;set curser
	mov dh, 4			;row
	mov dl, 15			;col
	mov ah, 2			;setcursor keyword
	int 10h

	;print string
	mov dx, offset gamename_str
	mov ah,09h
	int 21h


	;---print string---PLAY GAME 
	;set curser
	mov dh, 12      ;row for up down
	mov dl, 16     ;column for left rightJmuh
	mov ah, 2
	int 10h

	;print string
	mov    dx, offset playgame_str
	mov    ah,09h
	int    21h


	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 19     ;row for up down
	mov dl, 15     ;column for left right
	mov ah, 2
	int 10h

	;print string
	mov    dx, offset instructions_str
	mov    ah,09h
	int    21h


	;call display_score
	;////////user choice mechanism/////////
	call user_choice

ret
screen2 endp
;								make screen 2
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								instruction_page
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
instruction_page proc

	mov ah,0
	mov al,13h
	int 10h
	
	;draw line
	mov bl, 4				;line color
	mov linerow, 45			;initial row
	mov linecol, 113		;initial col
	mov linelength, 100		;length of line
	call drawline1          ;calling function


	;---print string---GAME NAME
	;set curser
	mov dh, 4			;row
	mov dl, 15			;col
	mov ah, 2			;setcursor keyword
	int 10h
	;print string
	mov    dx, offset gamename_str
	mov    ah,09h
	int    21h

	
	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 8     ;row for up down
	mov dl, 1     ;column for left right
	mov ah, 2
	int 10h
	;print string
	mov    dx, offset instructions_str
	mov    ah,09h
	int    21h


	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 10     ;row for up down
	mov dl, 2     ;column for left right
	mov ah, 2
	int 10h
	;print string
	mov    dx, offset instructions_str1
	mov    ah,09h
	int    21h

	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 12     ;row for up down
	mov dl, 2     ;column for left right
	mov ah, 2
	int 10h
	;print string
	mov    dx, offset instructions_str11
	mov    ah,09h
	int    21h

	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 15     ;row for up down
	mov dl, 2     ;column for left right
	mov ah, 2
	int 10h
	;print string
	mov    dx, offset instructions_str2
	mov    ah,09h
	int    21h

	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 18     ;row for up down
	mov dl, 2     ;column for left right
	mov ah, 2
	int 10h
	;print string
	mov    dx, offset instructions_str3
	mov    ah,09h
	int    21h

	;---print string---INSTUCTIONS 
	;set curser
	mov dh, 21     ;row for up down
	mov dl, 2     ;column for left right
	mov ah, 2
	int 10h
	;print string
	mov    dx, offset instructions_str4
	mov    ah,09h
	int    21h


	waitforkey:
	mov ah,1				;read a char from keyboard
	int 16h					;interept for keyboard input
	jnz keychoice			;if key entered
	jz waitforkey			;keep waiting if no key entered

		keychoice:
	
			mov ah,0			;read the scan code for key pressed
			int 16h

				;If enter pressed
				cmp al,27
				je escpressed		;esc pressed
				jmp waitforkey


				escpressed:
				call screen2

ret
instruction_page endp
;								instruction_page
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								Game Over Page
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Game_Over_page proc

	mov ah,0
	mov al,13h
	int 10h

	;---set background color---
	MOV AH, 06h
	MOV AL, 0
	MOV CX, 0
	MOV DH, 80
	MOV DL, 80
	MOV BH, 3 ;color
	INT 10h
	;--------------------------
	


ret
Game_Over_page endp
;								Game Over Page
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


;--------------------------------------------------
;DISPLAY SCORE
;--------------------------------------------------
display_score proc


;setting cursor position
mov dh, 8    ;row for up down
mov dl, 0    ;column for left right
mov ah, 2
int 10h
mov    dx, offset moves_str
mov    ah,09h
int    21h


;setting cursor position
mov dh, 8    ;row for up down
mov dl, 7    ;column for left right
mov ah, 2
int 10h
mov    dx, offset emptyStr 
mov    ah,09h
int    21h


;setting cursor position
mov dh, 8    ;row for up down
mov dl, 7    ;column for left right
mov ah, 2
int 10h


OUTPUT2:
    mov dx, 0
	MOV AX, move_number
	MOV Bx, 10
	L12:
        mov dx, 0
		CMP Ax, 0
		JE DISP2
		DIV Bx
		MOV cx, dx
		PUSH CX
		inc counter
		MOV AH, 0
		JMP L12

DISP2:
	CMP counter, 0
	JE EXIT112
	POP DX
	ADD DX, 48
	MOV AH, 02H
	INT 21H
	dec counter
	JMP DISP2

EXIT112:


;setting cursor position
mov dh, 4    ;row for up down
mov dl, 0    ;column for left right
mov ah, 2
int 10h

mov    dx, offset scoreStr
mov    ah,09h
int    21h

;setting cursor position
mov dh, 4    ;row for up down
mov dl, 7    ;column for left right
mov ah, 2
int 10h

mov    dx, offset emptyStr 
mov    ah,09h
int    21h

;setting cursor position
mov dh, 4    ;row for up down
mov dl, 7    ;column for left right
mov ah, 2
int 10h

OUTPUT:
    mov dx, 0
	MOV AX, score
	MOV Bx, 10
	L1:
        mov dx, 0
		CMP Ax, 0
		JE DISP
		DIV Bx
		MOV cx, dx
		PUSH CX
		inc counter
		MOV AH, 0
		JMP L1

DISP:
	CMP counter, 0
	JE EXIT11
	POP DX
	ADD DX, 48
	MOV AH, 02H
	INT 21H
	dec counter
	JMP DISP

EXIT11:

ret
display_score endp
;DISPLAY SCORE
;-----------------------------------------------------


;-----------------------------------------------------
;		Making a horizontal line
;-----------------------------------------------------
drawline1 proc

	mov cx, linecol
	mov dx, linerow
	mov ax, linelength
	add linecol, ax   

	lineloop:
	cmp cx,linecol
	je exitlineloop
		mov al, bl
		mov ah, 0ch
		int 10h

		inc cx
		jmp lineloop
	exitlineloop:
ret
drawline1 endp
;-----------------------------------------------------

;-----------------------------------------------------
;		Making a vertical line
;-----------------------------------------------------
drawline1v proc
	mov cx, linecol
	mov dx, linerow
	mov ax, linelength
	add linerow, ax   

	lineloopv:
	cmp dx,linerow
	je exitlineloopv
		mov al, bl
		mov ah, 0ch
		int 10h

		inc dx						;increment row for verticle line
		jmp lineloopv
	exitlineloopv:
ret
drawline1v endp
;-----------------------------------------------------

;-----------------------------------------------------
;		Making a Rectangle
;-----------------------------------------------------
rectangle proc

	;setting initial position
	mov ax,rectanglerow
	mov linerow, ax
	mov ax,rectanglecol
	mov linecol, ax

		;horizontal line
		mov ax, rectangle_b
		mov linelength,ax
		call drawline1

		;verticle line
		mov ax, rectangle_h
		mov linelength,ax
		call drawline1v
	
	;reset position
	mov ax, rectangle_b
	sub linecol,ax
	mov ax, rectangle_h
	sub linerow,ax
		
		;verticle line
		call drawline1v

		;horizontal line
		mov ax, rectangle_b
		mov linelength, ax
		call drawline1

ret	
rectangle endp
;-----------------------------------------------------

;-----------------------------------------------------
;					Code Delay
;-----------------------------------------------------
delay proc
   cmp delaytime,0
   je delay_exit_1
   mov si,0
   loopdel1:
         mov cx,999999999
         loop $
         inc si
         mov dx,delaytime
         cmp si,dx
         jle loopdel1
   delay_exit_1:
ret
delay endp
;					Code Delay
;-----------------------------------------------------


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								User Choice
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
user_choice proc

waitforkey:
	mov ah,1			;read a char from keyboard
	int 16h				;interept for keyboard input
	jnz keychoice		;if key entered
	jz waitforkey       ;keep waiting if no key entered

	keychoice:
			mov ah,0			;read the scan code for key pressed
			int 16h

			;If enter pressed
			cmp al,13
			je exitpressed

			;If down pressed
			cmp ah,50h
			je downpressed

			;If up pressed
			cmp ah,48h
			je uppressed

			jmp waitforkey


			;down pressed
			downpressed:
				
				cmp page1_counter, 2		;last option reached take input again
				je waitforkey

				cmp page1_counter, 1
				je movedown1



				;going to second box from first box
				movedown1:
						inc page1_counter

							;make box 1 yellow
							mov bl, 14				;color yellow rectangle
							mov rectanglerow, 90	;starting row
							mov rectanglecol, 107	;starting col
							mov rectangle_h, 19		;starting col
							mov rectangle_b, 114	;starting col
							call rectangle

							;make box 2 red
							mov bl, 4				;color yellow rectangle
							mov rectanglerow, 145	;starting row
							mov rectanglecol, 107	;starting col
							mov rectangle_h, 19		;starting col
							mov rectangle_b, 114	;starting col
							call rectangle
						
						jmp waitforkey ;jump back to wait for key loop
			
			
			;up pressed
			uppressed:
				
				cmp page1_counter, 1		;first option reached take input again
				je waitforkey

				cmp page1_counter, 2
				je moveup1



				;going to second box from first box
				moveup1:
						dec page1_counter

							;make box 2 yellow
							mov bl, 14				;color yellow rectangle
							mov rectanglerow, 145	;starting row
							mov rectanglecol, 107	;starting col
							mov rectangle_h, 19		;starting col
							mov rectangle_b, 114	;starting col
							call rectangle

							;make box 1 red
							mov bl, 4				;color yellow rectangle
							mov rectanglerow, 90 	;starting row
							mov rectanglecol, 107	;starting col
							mov rectangle_h, 19		;starting col
							mov rectangle_b, 114	;starting col
							call rectangle
						
						jmp waitforkey ;jump back to wait for key loop
			
			;exit pressed
			exitpressed:
				
				cmp page1_counter, 1
				je lets_play_game

				cmp page1_counter, 2
				je go_to_instructions


				lets_play_game:
				call play_game
				jmp byebye

				go_to_instructions:
				call instruction_page
				call screen2

				byebye:

ret
user_choice endp
;								User Choice
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								THE GAME LOOP
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	 
play_game proc

	mov ah,0
	mov al,13h
	int 10h

	;--set background color--
	MOV AH, 06h
	MOV AL, 0
	MOV CX, 0
	MOV DH, 80
	MOV DL, 80
			;Choosing background color based on level
			cmp level,1
			jne byebye
			MOV BH, 3 ;color

			cmp level,2
			jne byebye
			MOV BH, 10 ;color

			cmp level,3
			jne byebye
			MOV BH, 4 ;color

			byebye:
	INT 10h
	;-------------------------

	
	;--------draw line--------
	mov bl, 4				;line color
	mov linerow, 20			;initial row
	mov linecol, 115			;initial col
	mov linelength, 100		;length of line
	call drawline1          ;calling function
	;-------------------------


	;---Make Our Game Board---
	call makeboard
	;-------------------------


	;---Choosing Two Candies---
	call choosecandy
	;--------------------------


	;set curser
	mov dh, 4			;row
	mov dl, 15			;col
	mov ah, 2			;setcursor keyword
	int 10h
ret
play_game endp
;								THE GAME LOOP
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;								CHOOSE CANDY
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
choosecandy proc

;-------Our Red Rectangle used to select candy-------
mov bl, 4						;color red rectangle
mov rectanglerow, 43			;starting row
mov rectanglecol, 78			;starting col
mov rectangle_h, 18				;starting col
mov rectangle_b, 22				;starting col
call rectangle
;-----------------------------------------------------

;--count number of candies selected--
mov enter_counter, 0
;------------------------------------

waitforkey:

	mov ah,1			;read a char from keyboard
	int 16h				;interept for keyboard input
	jnz keychoice			;if key entered
	jz waitforkey       		;keep waiting if no key entered

	keychoice:
		mov ah,0			;read the scan code for key pressed
		int 16h

			;If enter pressed
			cmp al,13
			je exitpressed

			;If down pressed
			cmp ah,50h
			je downpressed

			;If up pressed
			cmp ah,48h
			je uppressed

			;If right pressed
			cmp ah,4Dh
			je rightpressed

			;If left pressed
			cmp ah,4Bh
			je leftpressed

			jmp waitforkey


			;down pressed
			downpressed:
					
					cmp enter_counter,1
					jne normalmovement1
						mov cx,choice1_row
						cmp count_row,cx
						jne out1
							mov cx,choice1_col
							cmp count_col,cx
							jne out1

							jmp correct1
						
					
					normalmovement1:
					;disapear old rectangle
					mov bl,3
					call rectangle

					correct1:

					;make box at new location
					mov bl,4
					add rectanglerow,21
														cmp level,2
														jne nolevel2
														cmp count_row,3
														jne nolevel2
																add rectanglerow,10
														nolevel2:

														cmp level,3
														jne nolevel3
														cmp count_row,3
														jne nolevel3
																add rectanglerow,10
														nolevel3:
					call rectangle
				
					;inc row as box moved dowwn
					inc count_row

					out1:

					cmp enter_counter, 1
					jne leave1
						mov cx,count_col
						cmp choice1_col,cx
						jne leave1
							mov cx,count_row
							inc cx
							cmp choice1_row,cx
							je normalmovement1

					leave1:

			jmp waitforkey

			;up pressed
			uppressed:

				cmp enter_counter,1
				jne normalmovement2
					mov cx,choice1_row
					cmp count_row,cx
					jne out2
						mov cx,choice1_col
						cmp count_col,cx
						jne out2

						jmp correct2

				normalmovement2:
				;disapear old rectangle
				mov bl,3
				call rectangle

				correct2:

				;make box at new location
				mov bl,4
				sub rectanglerow,21
														cmp level,2
														jne nolevel2up
														cmp count_row,4
														jne nolevel2up
																sub rectanglerow,10
														nolevel2up:

														cmp level,3
														jne nolevel3up
														cmp count_row,4
														jne nolevel3up
																sub rectanglerow,10
														nolevel3up:
				call rectangle
				
				;dec row as box moved dowwn
				dec count_row

				out2:

				cmp enter_counter, 1
					jne leave2
						mov cx,count_col
						cmp choice1_col,cx
						jne leave2
							mov cx,count_row
							dec cx
							cmp choice1_row,cx
							je normalmovement2

					leave2:

			jmp waitforkey

			;right pressed
			rightpressed:

				cmp enter_counter,1
				jne normalmovement3
					mov cx,choice1_row
					cmp count_row,cx
					jne out3
						mov cx,choice1_col
						cmp count_col,cx
						jne out3

						jmp correct3

				normalmovement3:

				;disapear old rectangle
				mov bl,3
				call rectangle

				correct3:

				;make box at new location
				mov bl,4
				add rectanglecol,25
														cmp level,3
														jne nolevel33
														cmp count_col,3
														jne nolevel33
																add rectanglecol,10
														nolevel33:

				call rectangle
				
				;inc col as box moved dowwn
				inc count_col

				out3:

				cmp enter_counter, 1
					jne leave3
						mov cx,count_col
						inc cx
						cmp choice1_col,cx
						jne leave3
							mov cx,count_row
							cmp choice1_row,cx
							je normalmovement3

					leave3:

			jmp waitforkey

			;left pressed
			leftpressed:

				cmp enter_counter,1
				jne normalmovement4
					mov cx,choice1_row
					cmp count_row,cx
					jne out4
						mov cx,choice1_col
						cmp count_col,cx
						jne out4

						jmp correct4

				normalmovement4:

				;disapear old rectangle
				mov bl,3
				call rectangle

				correct4:

				;make box at new location
				mov bl,4
				sub rectanglecol,25

														cmp level,3
														jne nolevel3b
														cmp count_col,4
														jne nolevel3b
																sub rectanglecol,10
														nolevel3b:


				call rectangle

				;dec col as box moved dowwn
				dec count_col

				out4:

				cmp enter_counter, 1
					jne leave4
						mov cx,count_col
						dec cx
						cmp choice1_col,cx
						jne leave4
							mov cx,count_row
							cmp choice1_row,cx
							je normalmovement4

					leave4:
				
			jmp waitforkey

			;enter pressed
			exitpressed:
				
				inc enter_counter

				;--If 1 Candy Selected--
				cmp enter_counter, 1
				je select_first_candy

				;-If 2 Candies Selected-
				cmp enter_counter,2
				je select_second_candy


				;--If 1 Candy Selected--
				select_first_candy:
					mov bx,count_row
					mov dx,count_col
					

					mov bl, 14						;color yellow rectangle
					sub rectanglerow, 1			;starting row
					sub rectanglecol, 1			;starting col
					mov rectangle_h, 20				;starting col
					mov rectangle_b, 24				;starting col
					call rectangle


					mov dx,count_row
					mov bx,count_col
					mov choice1_col,bx
					mov choice1_row,dx
					call getstatus
					mov choice1,ax

					jmp waitforkey		


				;--If 1 Candy Selected--
				select_second_candy:
					mov bx,count_row
					mov dx,count_col
					

					mov bl, 14						;color yellow rectangle
					sub rectanglerow, 1			;starting row
					sub rectanglecol, 1			;starting col
					mov rectangle_h, 20				;starting col
					mov rectangle_b, 24				;starting col
					call rectangle


					mov dx,count_row
					mov bx,count_col
					mov choice2_col,bx
					mov choice2_row,dx
					call getstatus
					mov choice2,ax

			;////////////////////////////////////////
			;		SWAPPING CANDIES 
			;////////////////////////////////////////
			mov dx, choice1_row
			mov bx, choice1_col
			mov ax, 0
			call changestatus

			mov dx, choice2_row
			mov bx, choice2_col
			mov ax, 0
			call changestatus

			call makeboard
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

			mov dx, choice1_row
			mov bx, choice1_col
			mov ax, choice2
			call changestatus
										
			mov dx, choice2_row
			mov bx, choice2_col
			mov ax, choice1
			call changestatus

			call makeboard
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			;////////////////////////////////////////
			;		SWAPPING CANDIES 
			;////////////////////////////////////////

					

			;-----------------------BOMB IS FOUND-----------------------
			cmp choice1,7
			je bomb_found1
			cmp choice2,7
			je bomb_found2
			jne nobomb

			bomb_found1:
			mov ax,choice2
			mov not_bomb,ax
			call explode_candies
			jmp bombfound

			bomb_found2:
			mov ax,choice1
			mov not_bomb,ax
			call explode_candies
			jmp bombfound
			;-----------------------------------------------------------

			;----no bomb found---
			nobomb:
					;[][][][][][][[][][[][][][][][][][][]]]
					;[][][][][][][[][][[][][][][][][][][]]]
					;[][][][][][][[][][[][][][][][][][][]]]
					;[][][][][][][[][][[][][][][][][][][]]]

					;---Disapear The candies that make a combo---
					call disapear_combo  
					call disapear_combo_col
					;--------------------------------------------

					;----no bomb found---
					bombfound:

					;--------------Update Game Board-------------
					call makeboard
					;--------------------------------------------
					
					;---Delay code---
					call delay
					call delay
					call delay
					call delay
					call delay
					call delay
					call delay

					;------Moving Candies Down For every col------
					mov j,0
					call new_candy
					mov j,1
					call new_candy
					mov j,2
					call new_candy
					mov j,3
					call new_candy
					mov j,4
					call new_candy
					mov j,5
					call new_candy
					mov j,6
					call new_candy
					;---------------------------------------------



					;--------------Update Game Board--------------
					call makeboard
					;---------------------------------------------

					;---Delay code---
					call delay
					call delay
					call delay
					call delay
					call delay
					call delay
					call delay

					;-----------adding candies to the top---------
					call move_down_candies  
					;---------------------------------------------
					
					;--------------Update Game Board--------------
					inc move_number
					call makeboard
					;---------------------------------------------

					;---Delay code---
					call delay
					call delay
					call delay
					call delay
					call delay
					call delay
					call delay

					;---Move Our Selection Box to Initial Position---
					mov enter_counter,0
					mov count_row,0
					mov count_col,0
					mov rectanglerow, 43			;starting row
					mov rectanglecol, 78			;starting col
					;------------------------------------------------


					;--------------Inrement Level When score---------
					cmp level,1
					jne level222
					cmp score,400
					jg gotolevel2
					
					level222:
					cmp score,700
					jg gotolevel3

					jmp nolevelincrement

					gotolevel2:
						mov level,2
						mov move_number,0
						call play_game
						jmp nolevelincrement

					gotolevel3:
						mov level,3
						mov move_number,0
						call play_game
						
					
					nolevelincrement:

					;--------------Move Limit Reached----------------
					mov ax,move_number
					cmp move_count,ax
					je leavegame
					;------------------------------------------------

					jmp waitforkey	

					leavegame:
					;call Game_Over_page


ret
choosecandy endp
;								CHOOSE CANDY
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

;////////////////////////////////////////////////////////////////////////////////
;								ADD_NEW_CANDY
;////////////////////////////////////////////////////////////////////////////////
new_candy proc

	;mov j,1
	mov zero_count,0 
	mov zero_index,0


			;////loop1.1//////
			mov end1,7
			mov i,0
			loop1:
							;\\\\\\\\\\\\\
							mov dx,i
							mov bx,j
							call getstatus
							cmp ax,0
							je yes1
									jmp out1

									yes1:
									inc zero_count

									;\\\\\\\\\\\\\\\
									cmp zero_count,1
									je yes2
											jmp out1

									yes2:
									mov bx,i
									dec bx
									mov zero_index,bx

							out1:

			inc i
			mov ax,i
			cmp end1,ax
			jne loop1

			cmp zero_count,0
			jne movedown 

					jmp dont_movedown

					movedown:
							;////loop1.3//////
							mov end1,0
							mov ax,zero_index
							mov i,ax
							loop2:

												mov bx,j
												mov dx,i
												call getstatus
												mov new_value,ax

												mov ax,i
												add ax,zero_count
												mov adding,ax

												mov bx,j
												mov dx,adding
												mov ax,new_value
												call changestatus

												mov bx,j
												mov dx,i
												mov ax,0
												call changestatus


							dec i
							mov ax,i
							cmp ax,end1
							jge loop2
					dont_movedown:


ret
new_candy endp
;								ADD_NEW_CANDY
;////////////////////////////////////////////////////////////////////////////////


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;							DISAPEAR COMBOS
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
disapear_combo proc

	;start1 dw ?
	;start2 dw ?
	;start3 dw ?

	;max_rows dw 7
	;max_cols dw 7
	;current_element dw ?
	;consecutive_count dw ?
	;candy_value dw ?
	;swap_check dw ?

	
	;first loop
	mov start1,0
	loop1:
				
				mov dx, start1
				mov bx, 0
				call getstatus
				mov current_element,ax

				mov consecutive_count, 1

				;second loop
				mov start2,1
				loop2:
								
								mov dx,start1
								mov bx,start2
								call getstatus
								mov candy_value,ax
								cmp current_element,ax
								je IF_BLOCK_A
									
									;ELSE_BLOCK
									mov ax, candy_value
									mov current_element, ax
									mov consecutive_count,1


									jmp END_IF_A

								IF_BLOCK_A:
									inc consecutive_count

									cmp consecutive_count,3
									jge IF_BLOCK_B

									jmp END_IF_B

									IF_BLOCK_B:
										
										;third loop
										mov bx, start2
										inc bx
										mov end1, bx

										mov dx, consecutive_count
										mov adding,dx
										;inc adding
										;inc adding

										sub bx, adding

										mov start3,bx
												loop3:
												
														mov dx,start1 ;row

														mov bx,start3 ;col

														mov ax, 0

														call changestatus

														;CANDY COUNT 
														mov ax,candy_value

														cmp ax,1
														je score_candy1
														cmp ax,2
														je score_candy2
														cmp ax,3
														je score_candy3
														cmp ax,4
														je score_candy4
														cmp ax,5
														je score_candy5
														jne exit

														score_candy1:
														mov cx,10
														add score,cx
														jmp exit

														score_candy2:
														mov cx,20
														add score,cx
														jmp exit

														score_candy3:
														mov cx,30
														add score,cx
														jmp exit

														score_candy4:
														mov cx,40
														add score,cx
														jmp exit
														
														score_candy5:
														mov cx,50
														add score,cx
														jmp exit

														exit:

												inc start3
												mov ax,start3
												cmp end1,ax
												jne loop3

								END_IF_B:
								END_IF_A:

				inc start2
				mov ax,start2
				cmp max_cols,ax
				jne loop2

	inc start1
	mov ax,start1
	cmp max_rows,ax
	jne loop1

ret
disapear_combo endp
;							DISAPEAR COMBOS
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 



;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;							DISAPEAR COMBOS
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
disapear_combo_col proc
	
	mov col_number,0
	loop1:
					mov dx,0
					mov bx,col_number
					call getstatus
					mov current_element,ax
					mov consecutive_count,1

					mov row_number,1
					loop2:
											mov dx,row_number
											mov bx,col_number
											call getstatus
											mov candy_value,ax
											cmp ax,current_element
											je if_a
												;else_a
													mov current_element,ax
													mov consecutive_count,1
													jmp endif1

												if_a:
													inc consecutive_count
													cmp consecutive_count,3
													jge if_b
														;else_b
															jmp endif1

														if_b:
															mov bx,row_number
															inc bx
															mov end1,bx  ;done

															cmp consecutive_count,bx
															jg consecutive_sub_end1
																;end1_sub_consecutive
																		sub bx,consecutive_count
																		mov start3,bx

																		jmp byebye
																consecutive_sub_end1:
																		mov dx,consecutive_count
																		sub dx,end1
																		mov start3,bx
															byebye:
																								;The calculation above gives us the starting row and ending row of loop
																								loop3:
																												mov dx,start3
																												mov bx,col_number
																												mov ax,0
																												call changestatus


																																										           ;CANDY COUNT 
																																													mov ax,candy_value

																																													cmp ax,1
																																													je score_candy1
																																													cmp ax,2
																																													je score_candy2
																																													cmp ax,3
																																													je score_candy3
																																													cmp ax,4
																																													je score_candy4
																																													cmp ax,5
																																													je score_candy5
																																													jne exit

																																													score_candy1:
																																													mov cx,10
																																													add score,cx
																																													jmp exit

																																													score_candy2:
																																													mov cx,20
																																													add score,cx
																																													jmp exit

																																													score_candy3:
																																													mov cx,30
																																													add score,cx
																																													jmp exit

																																													score_candy4:
																																													mov cx,40
																																													add score,cx
																																													jmp exit
														
																																													score_candy5:
																																													mov cx,50
																																													add score,cx
																																													jmp exit

																																													exit:
															
																								inc start3
																								mov ax,start3
																								cmp end1,ax
																								jne loop3
											endif1:

					inc row_number
					cmp row_number,7
					jne loop2

	inc col_number
	cmp col_number,7
	jne loop1
	


ret
disapear_combo_col endp
;							DISAPEAR COMBOS
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 



;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;							EXPLODE CANDIES COLUMN
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
explode_candies proc

	mov rows,7
	mov index_x,0
	loop1:
						mov cols,7
						mov index_y,0
						loop2:

						mov dx,index_x
						mov bx,index_y
						call getstatus
						cmp ax,not_bomb
						jne dont_explode

														mov cx,not_bomb
														add score,cx
														add score,cx
														add score,cx
														add score,cx
														add score,cx
														add score,cx

														candy_is_notbomb:
														mov dx,index_x
														mov bx,index_y
														mov ax,0
														call changestatus

						dont_explode:	
						
						mov dx,index_x
						mov bx,index_y
						call getstatus
						cmp ax,7
						jne not_a_bomb
														
														mov dx,index_x
														mov bx,index_y
														mov ax,0
														call changestatus


						not_a_bomb:

						inc index_y
						mov ax, cols
						cmp index_y,ax
						jne loop2	
	inc index_x
	mov ax, rows
	cmp index_x,ax
	jne loop1
ret
explode_candies endp
;							EXPLODE CANDIES
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

;\\\\\\\\\\\\\\\\\\\\\\\\\
;	move_down_candies Board
;\\\\\\\\\\\\\\\\\\\\\\\\\ 
move_down_candies proc

	mov retainvalue, ax

	mov candy1_col,79
	mov candy1_row,45
	mov candy1_color,4


	mov rows,7
	mov index_x,0
	loop1:

						

						mov cols,7
						mov index_y,0
						loop2:
															mov dx,index_x
															mov bx,index_y
															call getstatus

															cmp ax,0
															je random_candy
															jne exit

															
															random_candy:

																	inc random
																	cmp random,6
																	je yesrandom
																			jmp leaverandom
																	yesrandom:
																	mov random,1
																	leaverandom:


																	mov dx,index_x
																	mov bx,index_y
																	mov ax,random
																	call changestatus



																
												
															exit:





						inc index_y
						mov ax, cols
						cmp index_y,ax
						jne loop2	


	inc index_x
	mov ax, rows
	cmp index_x,ax
	jne loop1

	mov ax,retainvalue

	call display_score
ret
move_down_candies endp
;	move_down_candies
;\\\\\\\\\\\\\\\\\\\\\\\\\ 



;\\\\\\\\\\\\\\\\\\\\\\\\\
;	Make Board
;\\\\\\\\\\\\\\\\\\\\\\\\\ 
makeboard proc

	;call display_score

	mov retainvalue, ax

	mov candy1_col,79
	mov candy1_row,45
	mov candy1_color,4


	mov rows,7
	mov index_x,0
	loop1:

						mov candy1_col,79

						mov cols,7
						mov index_y,0
						loop2:
		
											mov dx,index_x
											mov bx,index_y
											call getstatus

											
											cmp ax,0
											je make_candy0

											cmp ax,1
											je make_candy1
											

											cmp ax,2
											je make_candy2
											
											
											cmp ax,3
											je make_candy3
											
											
											cmp ax,4
											je make_candy4
											
											
											cmp ax,5
											je make_candy5
										
											
											cmp ax,6
											je make_candy6
											

											cmp ax,7
											je make_candy7
											jne exit

											make_candy0:
												mov candy1_color,3
												call disappear
												jmp exit

											make_candy1:
												mov candy1_color,3
												call disappear
												mov candy1_color,4
												call candy1
												jmp exit

											make_candy2:
											    mov candy1_color,3
												call disappear
												mov candy1_color,2
												call candy2
												jmp exit
												
											make_candy3:
												mov candy1_color,3
												call disappear
												mov candy1_color,1
												call candy1
												jmp exit

											make_candy4:
												mov candy1_color,3
												call disappear
												mov candy1_color,5  ;puple color
												call candy2
												jmp exit

											make_candy5:
												mov candy1_color,3
												call disappear
												mov candy1_color,14
												call candy3
												jmp exit

											make_candy6:
												mov candy1_color,3
												call disappear
												mov candy1_color,12
												call candy3
												jmp exit

											make_candy7:
												mov candy1_color,3
												call disappear
												mov candy1_color,0
												call candy3
												jmp exit
												
											exit:

											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col
											inc candy1_col


																	cmp level,3
																	jne no_blocked_section3
																		cmp index_y,3
																		je blocked_section3
																			;noindexchange
																			jmp no_blocked_section3

																			blocked_section3:
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col
																								inc candy1_col

																	no_blocked_section3:



						inc index_y
						mov ax, cols
						cmp index_y,ax
						jne loop2	
						
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row
						inc candy1_row

						cmp level,2
						jne no_blocked_section
							cmp index_x,3
							je blocked_section
								;noindexchange
								jmp no_blocked_section

								blocked_section:
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row

						no_blocked_section:


						cmp level,3
						jne no_blocked_sectionb
							cmp index_x,3
							je blocked_sectionb
								;noindexchange
								jmp no_blocked_sectionb

								blocked_sectionb:
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row
													inc candy1_row

						no_blocked_sectionb:



	inc index_x
	mov ax, rows
	cmp index_x,ax
	jne loop1

	mov ax,retainvalue

	;---print string---
	;set curser
	mov dh, 1			;row
	mov dl, 15			;col
	mov ah, 2			;setcursor keyword
	int 10h

	;print string
	mov dx, offset gamename_str
	mov ah,09h
	int 21h

	call display_score
ret
makeboard endp
;\\\\\\\\\\\\\\\\\\\\\\\\\
;	Make Board
;\\\\\\\\\\\\\\\\\\\\\\\\\ 

getstatus proc
	mov si,offset board


	mov to_multiply1, bx
	mov to_multiply2, dx

	add bx,to_multiply1

	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2

	add bx,dx

	mov ax,[si+bx]
ret
getstatus endp

changestatus proc
	mov si,offset board

	mov to_multiply1, bx
	mov to_multiply2, dx

	add bx,to_multiply1

	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2
	add dx,to_multiply2

	add bx,dx

	;mov [si+bx],ax
	mov [si+bx],ax
ret
changestatus endp


;\\\\\\\\\\\\\\\\\\\\\\\\\
;	Disappear
;\\\\\\\\\\\\\\\\\\\\\\\\\ 
disappear proc

dec candy1_col
dec candy1_col

dec candy1_row
dec candy1_row

dec candy1_col
dec candy1_row

dec candy1_col
dec candy1_row

	mov ah,0ch
	mov al,3					;color
	mov cx,candy1_col
	mov dx,candy1_row
	int 10h
	
	;/////////////////////////////////////////////////////
	mov bx, 2						;loop size or length of pixels
	mov loop_count,1
	loop1:

		cmp loop_count,1
		je change_color1
		cmp loop_count,2
		je change_color1
		jne exit_change_color1
		change_color1:
			mov al, 3
		exit_change_color1:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop1
	;//////////////////////////////////////////////////

	;/////////////////////////////////////////////////////
	mov bx, 26						;loop size or length of pixels
	mov loop_count,1
	loop2:

		cmp loop_count,1
		je change_color2

		cmp loop_count,3
		je change_color2

		jne exit_change_color2
		change_color2:
			mov al, 3
		exit_change_color2:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop2
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop3:

		cmp loop_count,1
		je change_color3
		cmp loop_count,5
		je change_color3
		jne exit_change_color3
		change_color3:
			mov al, 3
		exit_change_color3:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop3
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop4:

		cmp loop_count,1
		je change_color4
		cmp loop_count,7
		je change_color4
		jne exit_change_color4
		change_color4:
			mov al, 3
		exit_change_color4:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop4
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx


	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop5:

		cmp loop_count,1
		je change_color5
		cmp loop_count,9
		je change_color5
		jne exit_change_color5
		change_color5:
			mov al, 3
		exit_change_color5:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop5
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx
	
	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop6:

		cmp loop_count,1
		je change_color6
		cmp loop_count,11
		je change_color6
		jne exit_change_color6
		change_color6:
			mov al, 3
		exit_change_color6:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop6
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop7:

		cmp loop_count,1
		je change_color7
		cmp loop_count,11
		je change_color7
		jne exit_change_color7
		change_color7:
			mov al, 3
		exit_change_color7:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop7
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx
	
	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop8:

		cmp loop_count,1
		je change_color8
		cmp loop_count,13
		je change_color8
		jne exit_change_color8
		change_color8:
			mov al, 3
		exit_change_color8:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop8
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop9:

		cmp loop_count,1
		je change_color9
		cmp loop_count,13
		je change_color9
		jne exit_change_color9
		change_color9:
			mov al, 3
		exit_change_color9:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop9
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop10:

		cmp loop_count,1
		je change_color10
		cmp loop_count,13
		je change_color10
		jne exit_change_color10
		change_color10:
			mov al, 3
		exit_change_color10:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop10
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop11:

		cmp loop_count,1
		je change_color11
		cmp loop_count,11
		je change_color11
		jne exit_change_color11
		change_color11:
			mov al, 3
		exit_change_color11:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop11
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop12:

		cmp loop_count,1
		je change_color12
		cmp loop_count,11
		je change_color12
		jne exit_change_color12
		change_color12:
			mov al, 3
		exit_change_color12:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop12
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop13:

		cmp loop_count,1
		je change_color13
		cmp loop_count,9
		je change_color13
		jne exit_change_color13
		change_color13:
			mov al, 3
		exit_change_color13:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop13
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop14:

		cmp loop_count,1
		je change_color14
		cmp loop_count,7
		je change_color14

		jne exit_change_color14
		change_color14:
			mov al, 3
		exit_change_color14:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop14
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop15:

		cmp loop_count,1
		je change_color15
		cmp loop_count,5
		je change_color15
		jne exit_change_color15
		change_color15:
			mov al, 3
		exit_change_color15:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop15
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop16:

		cmp loop_count,1
		je change_color16
		cmp loop_count,5
		je change_color16
		jne exit_change_color16
		change_color16:
			mov al, 3
		exit_change_color16:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop16
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop17:

		cmp loop_count,1
		je change_color17
		cmp loop_count,5
		je change_color17
		jne exit_change_color17
		change_color17:
			mov al, 3
		exit_change_color17:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop17
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop18:

		cmp loop_count,1
		je change_color18
		cmp loop_count,5
		je change_color18
		jne exit_change_color18
		change_color18:
			mov al, 3
		exit_change_color18:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop18
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop19:

		cmp loop_count,1
		je change_color19
		cmp loop_count,5
		je change_color19
		jne exit_change_color19
		change_color19:
			mov al, 3
		exit_change_color19:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop19
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop20:

		cmp loop_count,1
		je change_color20
		cmp loop_count,5
		je change_color20
		jne exit_change_color20
		change_color20:
			mov al, 3
		exit_change_color20:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop20
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop21:

		cmp loop_count,1
		je change_color21
		cmp loop_count,5
		je change_color21
		jne exit_change_color21
		change_color21:
			mov al, 3
		exit_change_color21:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop21
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop22:

		cmp loop_count,1
		je change_color22
		cmp loop_count,5
		je change_color22
		jne exit_change_color22
		change_color22:
			mov al, 3
		exit_change_color22:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop22
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 27						;loop size or length of pixels
	mov loop_count,1
	loop23:

		cmp loop_count,1
		je change_color23
		cmp loop_count,5
		je change_color23
		jne exit_change_color23
		change_color23:
			mov al, 3
		exit_change_color23:
			inc cx
			int 10h
			mov al, 3

		inc loop_count
		cmp loop_count, bx
	jne loop23
	;//////////////////////////////////////////////////


	inc candy1_col
	inc candy1_col

	inc candy1_row
	inc candy1_row

	inc candy1_col
	inc candy1_row

	inc candy1_col
	inc candy1_row

ret 
disappear endp

;\\\\\\\\\\\\\\\\\\\\\\\\\--------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;	CANDY 1
;\\\\\\\\\\\\\\\\\\\\\\\\\\-------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

;\\\\\\\\\\\\\\\\\\\\\\\\\
;	CANDY 1
;\\\\\\\\\\\\\\\\\\\\\\\\\ 
candy1 proc
	mov ah,0ch
	mov al,candy1_color				;color
	mov cx,candy1_col
	mov dx,candy1_row
	int 10h
	

	mov bx, 2
	mov loop_count,1
	loop1:

		inc cx


		inc loop_count
		cmp loop_count, bx
		jne loop1


	mov bx, 8
	mov loop_count,1
	loop2:

		cmp loop_count,1
		je change_color00

		cmp loop_count,8
		je change_color00
		jne exit_change_color00

		change_color00:
			mov al, 0

		exit_change_color00:
			

		inc cx
		int 10h
		mov al, 0

		inc loop_count
		cmp loop_count, bx
		jne loop2
				

	;next line
	mov cx,candy1_col
	inc dx

	inc cx


	mov bx, 9
	mov loop_count,1
	loop3:

		cmp loop_count,1
		je change_color0

		cmp loop_count,8
		je change_color0
		jne exit_change_color0

		change_color0:
			mov al, 0

		exit_change_color0:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop3

	;next line
	mov cx,candy1_col
	inc dx
	
	mov bx, 11
	mov loop_count,1
	loop4:

		cmp loop_count,10
		je newcolor

		cmp loop_count,1
		je newcolor

		cmp loop_count,6
		je change_color

		cmp loop_count,4
		je change_color

		cmp loop_count,5
		je change_color
		jne exit_change_color

		change_color:
			mov al, 15
		jmp exit_change_color

		newcolor:
			mov al, 0

		exit_change_color:
			

		inc cx
		int 10h
			mov al, candy1_color
		inc loop_count
		cmp loop_count, bx
		jne loop4


	;next line
	mov cx,candy1_col
	inc dx

	mov bx, 12
	mov loop_count,1
	loop5:

		cmp loop_count,6
		je color_color

		cmp loop_count,1
		je change_color1

		cmp loop_count,11
		je change_color1
		jne exit_change_color1

		change_color1:
			mov al, 0
		jmp exit_change_color1

		color_color:
			mov al, 15

		exit_change_color1:
			
		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop5

	;next line
	mov cx,candy1_col
	inc dx

	mov bx, 13
	mov loop_count,1
	loop6:

		cmp loop_count,1
		je change_color2

		cmp loop_count,12
		je change_color2
		jne exit_change_color2

		change_color2:
			mov al, 0

		exit_change_color2:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop6

	;next line
	mov cx,candy1_col
	inc dx


	mov bx, 15
	mov loop_count,1
	loop7:

		cmp loop_count,1
		je change_color3

		cmp loop_count,13
		je change_color3

		cmp loop_count,14
		je change_color3
		jne exit_change_color3

		change_color3:
			mov al, 0

		exit_change_color3:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop7

	;next line
	mov cx,candy1_col
	inc dx


	mov bx, 16
	mov loop_count,1
	loop8:

		cmp loop_count,1
		je change_color4

		cmp loop_count,15
		je change_color4
		jne exit_change_color4

		change_color4:
			mov al, 0

		exit_change_color4:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop8

	;next line
	mov cx,candy1_col
	inc dx

	mov bx, 17
	mov loop_count,1
	loop9:

		cmp loop_count,1
		je change_color5

		cmp loop_count,16
		je change_color5
		jne exit_change_color5

		change_color5:
			mov al, 0

		exit_change_color5:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop9

	;next line
	mov cx,candy1_col
	inc dx

	mov bx, 18
	mov loop_count,1
	loop10:

		cmp loop_count,1
		je change_color6

		cmp loop_count,2
		je change_color6

		cmp loop_count,17
		je change_color6
		jne exit_change_color6

		change_color6:
			mov al, 0

		exit_change_color6:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop10

	;next line
	mov cx,candy1_col
	inc dx

	inc cx

	mov bx, 18
	mov loop_count,1
	loop11:

		cmp loop_count,1
		je change_color7

		cmp loop_count,17
		je change_color7
		jne exit_change_color7

		change_color7:
			mov al, 0

		exit_change_color7:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop11

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx

	mov bx, 17
	mov loop_count,1
	loop12:

		cmp loop_count,1
		je change_color8

		cmp loop_count,2
		je change_color8

		cmp loop_count,16
		je change_color8
		jne exit_change_color8

		change_color8:
			mov al, 0

		exit_change_color8:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop12

	;next line
	mov cx,candy1_col
	inc dx
	
	inc cx
	inc cx
	inc cx
	inc cx

	mov bx, 15
	mov loop_count,1
	loop13:

		cmp loop_count,1
		je change_color9

		cmp loop_count,14
		je change_color9
		jne exit_change_color9

		change_color9:
			mov al, 0

		exit_change_color9:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop13

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	inc cx
	inc cx

	mov bx, 14
	mov loop_count,1
	loop14:

		cmp loop_count,1
		je change_color10

		cmp loop_count,13
		je change_color10
		jne exit_change_color10

		change_color10:
			mov al, 0

		exit_change_color10:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop14

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx

	mov bx, 12
	mov loop_count,1
	loop15:

		cmp loop_count,1
		je change_color11

		cmp loop_count,2
		je change_color11

		cmp loop_count,3
		je change_color11

		cmp loop_count,11
		je change_color11
		jne exit_change_color11

		change_color11:
			mov al, 0

		exit_change_color11:
			

		inc cx
		int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
		jne loop15

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx

	mov bx, 8
	mov loop_count,1
	loop16:

		cmp loop_count,1
		je change_color12

		cmp loop_count,8
		je change_color12
		jne exit_change_color12

		change_color12:
			mov al, 0

		exit_change_color12:
			

		inc cx
		int 10h
			mov al, 0

		inc loop_count
		cmp loop_count, bx
		jne loop16

	;next line
	mov cx,candy1_col
	inc dx

ret
candy1 endp
;\\\\\\\\\\\\\\\\\\\\\\\\\
;	CANDY 1
;\\\\\\\\\\\\\\\\\\\\\\\\\ 







;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;   Candy2 CANDY
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

candy2 proc

	mov ah,0ch
	mov al,candy1_color				;color
	mov cx,candy1_col
	mov dx,candy1_row
	int 10h
	
	inc cx
	inc cx

	;/////////////////////////////////////////////////////
	mov bx, 16						;loop size or length of pixels
	mov loop_count,1
	loop1:

		cmp loop_count,1
		je change_color1
		cmp loop_count,15
		je change_color1
		jne exit_change_color1
		change_color1:
			mov al, 0
		exit_change_color1:
			inc cx
			int 10h
			mov al, 0

		inc loop_count
		cmp loop_count, bx
	jne loop1
	;//////////////////////////////////////////////////
		
	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 20						;loop size or length of pixels
	mov loop_count,1
	loop2:

		cmp loop_count,1
		je change_color2
		cmp loop_count,2
		je change_color2
		cmp loop_count,3
		je change_color2
		cmp loop_count,19
		je change_color2
		cmp loop_count,18
		je change_color2
		cmp loop_count,17
		je change_color2
		jne exit_change_color2
		change_color2:
			mov al, 0
		exit_change_color2:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop2
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 18						;loop size or length of pixels
	mov loop_count,1
	loop3:

		cmp loop_count,1
		je change_color3
		cmp loop_count,17
		je change_color3
		jne exit_change_color3
		change_color3:
			mov al, 0
		exit_change_color3:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop3
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 16						;loop size or length of pixels
	mov loop_count,1
	loop4:

		cmp loop_count,1
		je change_color4
		cmp loop_count,15
		je change_color4
		jne exit_change_color4
		change_color4:
			mov al, 0
		exit_change_color4:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop4
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 16						;loop size or length of pixels
	mov loop_count,1
	loop5:

		cmp loop_count,1
		je change_color5
		cmp loop_count,15
		je change_color5
		jne exit_change_color5
		change_color5:
			mov al, 0
		exit_change_color5:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop5
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop6:

		cmp loop_count,1
		je change_color6
		cmp loop_count,13
		je change_color6
		jne exit_change_color6
		change_color6:
			mov al, 0
		exit_change_color6:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop6
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop7:

		cmp loop_count,1
		je change_color7
		cmp loop_count,13
		je change_color7
		jne exit_change_color7
		change_color7:
			mov al, 0
		exit_change_color7:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop7
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop8:

		cmp loop_count,1
		je change_color8
		cmp loop_count,13
		je change_color8
		jne exit_change_color8
		change_color8:
			mov al, 0
		exit_change_color8:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop8
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop9:

		cmp loop_count,1
		je change_color9
		cmp loop_count,13
		je change_color9
		jne exit_change_color9
		change_color9:
			mov al, 0
		exit_change_color9:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop9
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop10:

		cmp loop_count,1
		je change_color10
		cmp loop_count,13
		je change_color10
		jne exit_change_color10
		change_color10:
			mov al, 0
		exit_change_color10:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop10
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 16						;loop size or length of pixels
	mov loop_count,1
	loop11:

		cmp loop_count,1
		je change_color11
		cmp loop_count,15
		je change_color11
		jne exit_change_color11
		change_color11:
			mov al, 0
		exit_change_color11:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop11
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 16						;loop size or length of pixels
	mov loop_count,1
	loop12:

		cmp loop_count,1
		je change_color12
		cmp loop_count,15
		je change_color12
		jne exit_change_color12
		change_color12:
			mov al, 0
		exit_change_color12:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop12
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 18						;loop size or length of pixels
	mov loop_count,1
	loop13:

		cmp loop_count,1
		je change_color13
		cmp loop_count,17
		je change_color13
		jne exit_change_color13
		change_color13:
			mov al, 0
		exit_change_color13:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop13
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	;/////////////////////////////////////////////////////
	mov bx, 20						;loop size or length of pixels
	mov loop_count,1
	loop14:

		cmp loop_count,3
		je change_color14
		cmp loop_count,17
		je change_color14
		cmp loop_count,1
		je change_color14
		cmp loop_count,19
		je change_color14
		cmp loop_count,2
		je change_color14
		cmp loop_count,18
		je change_color14
		jne exit_change_color14
		change_color14:
			mov al, 0
		exit_change_color14:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop14
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 16						;loop size or length of pixels
	mov loop_count,1
	loop15:

		cmp loop_count,1
		je change_color15
		cmp loop_count,17
		je change_color15
		jne exit_change_color15
		change_color15:
			mov al, 0
		exit_change_color15:
			inc cx
			int 10h
			mov al, 0

		inc loop_count
		cmp loop_count, bx
	jne loop15
	;//////////////////////////////////////////////////
       
    ret
candy2 endp






;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;   Candy3 CANDY
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

candy3 proc

	mov ah,0ch
	mov al,candy1_color				;color
	mov cx,candy1_col
	mov dx,candy1_row
	int 10h
	
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	

	;/////////////////////////////////////////////////////
	mov bx, 2						;loop size or length of pixels
	mov loop_count,1
	loop1:

		cmp loop_count,1
		je change_color1
		cmp loop_count,2
		je change_color1
		jne exit_change_color1
		change_color1:
			mov al, 0
		exit_change_color1:
			inc cx
			int 10h
			mov al, 0

		inc loop_count
		cmp loop_count, bx
	jne loop1
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx

	;/////////////////////////////////////////////////////
	mov bx, 4						;loop size or length of pixels
	mov loop_count,1
	loop2:

		cmp loop_count,1
		je change_color2

		cmp loop_count,3
		je change_color2

		jne exit_change_color2
		change_color2:
			mov al, 0
		exit_change_color2:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop2
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 6						;loop size or length of pixels
	mov loop_count,1
	loop3:

		cmp loop_count,1
		je change_color3
		cmp loop_count,5
		je change_color3
		jne exit_change_color3
		change_color3:
			mov al, 0
		exit_change_color3:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop3
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 8						;loop size or length of pixels
	mov loop_count,1
	loop4:

		cmp loop_count,1
		je change_color4
		cmp loop_count,7
		je change_color4
		jne exit_change_color4
		change_color4:
			mov al, 0
		exit_change_color4:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop4
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 10						;loop size or length of pixels
	mov loop_count,1
	loop5:

		cmp loop_count,1
		je change_color5
		cmp loop_count,9
		je change_color5
		jne exit_change_color5
		change_color5:
			mov al, 0
		exit_change_color5:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop5
	;//////////////////////////////////////////////////


	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 12						;loop size or length of pixels
	mov loop_count,1
	loop6:

		cmp loop_count,1
		je change_color6
		cmp loop_count,11
		je change_color6
		jne exit_change_color6
		change_color6:
			mov al, 0
		exit_change_color6:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop6
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 12						;loop size or length of pixels
	mov loop_count,1
	loop7:

		cmp loop_count,1
		je change_color7
		cmp loop_count,11
		je change_color7
		jne exit_change_color7
		change_color7:
			mov al, 0
		exit_change_color7:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop7
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop8:

		cmp loop_count,1
		je change_color8
		cmp loop_count,13
		je change_color8
		jne exit_change_color8
		change_color8:
			mov al, 0
		exit_change_color8:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop8
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop9:

		cmp loop_count,1
		je change_color9
		cmp loop_count,13
		je change_color9
		jne exit_change_color9
		change_color9:
			mov al, 0
		exit_change_color9:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop9
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	
	;/////////////////////////////////////////////////////
	mov bx, 14						;loop size or length of pixels
	mov loop_count,1
	loop10:

		cmp loop_count,1
		je change_color10
		cmp loop_count,13
		je change_color10
		jne exit_change_color10
		change_color10:
			mov al, 0
		exit_change_color10:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop10
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 12						;loop size or length of pixels
	mov loop_count,1
	loop11:

		cmp loop_count,1
		je change_color11
		cmp loop_count,11
		je change_color11
		jne exit_change_color11
		change_color11:
			mov al, 0
		exit_change_color11:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop11
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 12						;loop size or length of pixels
	mov loop_count,1
	loop12:

		cmp loop_count,1
		je change_color12
		cmp loop_count,11
		je change_color12
		jne exit_change_color12
		change_color12:
			mov al, 0
		exit_change_color12:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop12
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 10						;loop size or length of pixels
	mov loop_count,1
	loop13:

		cmp loop_count,1
		je change_color13
		cmp loop_count,9
		je change_color13
		jne exit_change_color13
		change_color13:
			mov al, 0
		exit_change_color13:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop13
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	inc cx

	;/////////////////////////////////////////////////////
	mov bx, 8						;loop size or length of pixels
	mov loop_count,1
	loop14:



		cmp loop_count,1
		je change_color14
		cmp loop_count,7
		je change_color14

		jne exit_change_color14
		change_color14:
			mov al, 0
		exit_change_color14:
			inc cx
			int 10h
			mov al, candy1_color

		inc loop_count
		cmp loop_count, bx
	jne loop14
	;//////////////////////////////////////////////////

	;next line
	mov cx,candy1_col
	inc dx

	
	inc cx
	inc cx
	inc cx
	inc cx
	inc cx
	;/////////////////////////////////////////////////////
	mov bx, 6						;loop size or length of pixels
	mov loop_count,1
	loop15:

		cmp loop_count,1
		je change_color15
		cmp loop_count,5
		je change_color15
		jne exit_change_color15
		change_color15:
			mov al, 0
		exit_change_color15:
			inc cx
			int 10h
			mov al, 0

		inc loop_count
		cmp loop_count, bx
	jne loop15
	;//////////////////////////////////////////////////

ret
candy3 endp


end

