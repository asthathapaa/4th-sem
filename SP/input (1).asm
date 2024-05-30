COPY        START   0000
            EXTDEF  BUFFER, BUFFEND, LENGTH
            EXTREF  RDREC, WRREC
FIRST       STL     RETADR
CLOOP       +JSUB   RDREC
            LDA     LENGTH
            COMP    #0
            JEQ     ENDFILL
            +JSUB   WRREC
            J       CLOOP
ENDFILL     LDA     =C'EOF'
            STA     BUFFER
            LDA	    #3
            STA     LENGTH
            +JSUB   WRREC
            J       @RETADR
RETADR      RESW    1
LENGTH      RESW    1
            LTORG
           =C'EOF'
BUFFER      RESB    4096
BUFFEND     EQU     
MAXLEN      EQU     BUFFEND-BUFFER
RDREC       CSECT
            EXTREF  BUFFER,LENGTH,BUFFEND
            CLEAR   X
            CLEAR   A
            CLEAR   S
            LDT     MAXLEN
RLOOP       TD      INPUT
            JEQ     RLOOP
            RD      INPUT
            COMPR   A,S 
            JEQ     EXIT
            +STCH   BUFFER,X
            TIXR    T
            JLT     RLOOP
EXIT        +STX    LENGTH
            RSUB
INPUT       BYTE    X'F1'
MAXLEN      WORD    BUFFEND-BUFFER
WRREC       CSECT
            EXTREF  LENGTH,BUFFER
            CLEAR   X
            +LDT    LENGTH
WLOOP       TD      =X'05'
            JEQ     WLOOP
            +LDCH   BUFFER,X
            WD      =X'05'
            TIXR    T
            JLT     WLOOP
            RSUB
            END     FIRST
            =X'05'

