;
;   Proactive Computer Security
;   Assignment 4, Stack Overflow
;
;   Author: Casper B. Hansen, fvx507@alumni.ku.dk
;
;   Description:
;   Commented objdump excerpt of the parrot executable.
;
;   Stack Frame:
;
;           |-------------|
;           | XX XX XX XX |     Argument (argv[1], char *)
;           |-------------|
;           | 51 85 04 08 |     Return Address
;           |-------------|
;   EBP ->  | XX XX XX XX |     Saved EBP
;           |-------------|
;           | CC CC CC CC |     [EBP - 0x0C], Stack Cookie
;           |-------------|
;           | LL LL LL LL |     [EBP - 0x10], Buffer Pointer
;           |-------------|
;             .. .. .. ..       ...
;           |-------------|
;           | XX XX XX XX |     [EBP - 0x38], char[40]
;           |-------------|
;           | YY YY YY YY |     [EBP - 0x3C], argv[1]
;           |-------------|
;           | YY YY YY YY |     [EBP - 0x44], unused it seems
;           |-------------|
;           | YY YY YY YY |     [EBP - 0x4C], argv[1]
;           |-------------|
;

080484cc <parse>:
 ; function prolog
 80484cc:	55                   	push   ebp
 80484cd:	89 e5                	mov    ebp,esp
 80484cf:	83 ec 68             	sub    esp,0x68

 ; char * str = argv[1]
 80484d2:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 80484d5:	89 45 b4             	mov    DWORD PTR [ebp-0x4c],eax
 
 ; stack cookie at [ebp-0xC]
 80484d8:	65 a1 14 00 00 00    	mov    eax,gs:0x14
 80484de:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax

 ; char buffer[40]
 80484e1:	31 c0                	xor    eax,eax
 80484e3:	8b 45 b4             	mov    eax,DWORD PTR [ebp-0x4c]     ; ebp-0x4C unused, remnant
 80484e6:	89 45 c4             	mov    DWORD PTR [ebp-0x3c],eax     ; char *str = argv[1]
 80484e9:	c7 45 f0 00 00 00 00 	mov    DWORD PTR [ebp-0x10],0x0     ; char *ptr = null
 80484f0:	eb 1b                	jmp    804850d <parse+0x41>
 
 ; LOOP - while (ptr != null)
 80484f2:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]     ; ptr *
 80484f5:	8b 4d c4             	mov    ecx,DWORD PTR [ebp-0x3c]     ; str *
 80484f8:	8b 55 f0             	mov    edx,DWORD PTR [ebp-0x10]     ; ptr *
 
 ; copy i'th character to buffer[i]
 80484fb:	01 ca                	add    edx,ecx                      ; buffer[i] = (* ptr)
 80484fd:	0f b6 12             	movzx  edx,BYTE PTR [edx]           ; 
 8048500:	88 54 05 c8          	mov    BYTE PTR [ebp+eax*1-0x38],dl ; 
 8048504:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]     ; ptr++;
 8048507:	83 c0 01             	add    eax,0x1                      ; 
 804850a:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax     ;

 ; loop advancement
 804850d:	8b 55 c4             	mov    edx,DWORD PTR [ebp-0x3c]     ; str *
 8048510:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]     ; ptr *
 8048513:	01 d0                	add    eax,edx                      ; ptr += str

 ; loop condition
 8048515:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 8048518:	84 c0                	test   al,al
 804851a:	75 d6                	jne    80484f2 <parse+0x26>
 
 ; printf("You gave me \"%.*s\". Not bad.", str, length)
 804851c:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
 804851f:	8d 55 c4             	lea    edx,[ebp-0x3c]
 8048522:	83 c2 04             	add    edx,0x4
 8048525:	89 54 24 08          	mov    DWORD PTR [esp+0x8],edx
 8048529:	89 44 24 04          	mov    DWORD PTR [esp+0x4],eax
 804852d:	c7 04 24 40 86 04 08 	mov    DWORD PTR [esp],0x8048640
 8048534:	e8 57 fe ff ff       	call   8048390 <printf@plt>

 ; XOR stack cookie check
 8048539:	b8 00 00 00 00       	mov    eax,0x0
 804853e:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
 8048541:	65 33 15 14 00 00 00 	xor    edx,DWORD PTR gs:0x14
 8048548:	74 05                	je     804854f <parse+0x83>
 804854a:	e8 51 fe ff ff       	call   80483a0 <__stack_chk_fail@plt>
 
 ; function epilog
 804854f:	c9                   	leave  
 8048550:	c3                   	ret    

08048551 <main>:
 ; function prolog
 8048551:	55                   	push   ebp
 8048552:	89 e5                	mov    ebp,esp
 8048554:	83 e4 f0             	and    esp,0xfffffff0
 8048557:	83 ec 10             	sub    esp,0x10

 ; if (argc != 2)
 804855a:	83 7d 08 02          	cmp    DWORD PTR [ebp+0x8],0x2
 804855e:	74 25                	je     8048585 <main+0x34>

 ; printf("Usage: %s string.", argv[0]);
 8048560:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 8048563:	8b 10                	mov    edx,DWORD PTR [eax]
 8048565:	a1 3c 98 04 08       	mov    eax,ds:0x804983c
 804856a:	89 54 24 08          	mov    DWORD PTR [esp+0x8],edx
 804856e:	c7 44 24 04 5e 86 04 	mov    DWORD PTR [esp+0x4],0x804865e
 8048575:	08 
 8048576:	89 04 24             	mov    DWORD PTR [esp],eax
 8048579:	e8 52 fe ff ff       	call   80483d0 <fprintf@plt>
 804857e:	b8 01 00 00 00       	mov    eax,0x1
 8048583:	eb 20                	jmp    80485a5 <main+0x54>

 ; int rc = parse(argv[1])
 8048585:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 8048588:	83 c0 04             	add    eax,0x4
 804858b:	8b 00                	mov    eax,DWORD PTR [eax]
 804858d:	89 04 24             	mov    DWORD PTR [esp],eax
 8048590:	e8 37 ff ff ff       	call   80484cc <parse>
 
 ; return rc;
 8048595:	85 c0                	test   eax,eax
 8048597:	74 07                	je     80485a0 <main+0x4f>
 8048599:	b8 01 00 00 00       	mov    eax,0x1
 804859e:	eb 05                	jmp    80485a5 <main+0x54>
 80485a0:	b8 00 00 00 00       	mov    eax,0x0
 
 ; function epilog
 80485a5:	c9                   	leave  
 80485a6:	c3                   	ret    
 80485a7:	90                   	nop
 80485a8:	90                   	nop
 80485a9:	90                   	nop
 80485aa:	90                   	nop
 80485ab:	90                   	nop
 80485ac:	90                   	nop
 80485ad:	90                   	nop
 80485ae:	90                   	nop
 80485af:	90                   	nop

