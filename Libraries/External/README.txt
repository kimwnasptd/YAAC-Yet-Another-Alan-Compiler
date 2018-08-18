To build : 
>./libs.sh

A file called 'lib.a' is generated

----------------------------------------------------------------------------------
abs : di -> ax
atan : stack -> st0
cos : stack -> st0
exp : stack -> st0
fabs : stack -> st0
ln : stack -> st0
pi : - -> st0
sin : stack -> st0
sqrt : stack -> st0
tan : stack -> st0

readBoolean : - -> al
readCharacter : - -> al
readInteger : - -> ax
readReal : - -> st0
readString : rdi (size), rsi (pointer to char array) -> -
writeBoolean : dil -> -
writeCharacter : dil -> -
writeInteger : di -> -
writeReal : stack -> -
writeString : rdi (pointer to char array) -> -


chr : dil -> al
exit : di -> -
ord : dil -> ax
round : stack -> ax
trunc : stack -> ax

strcat : rdi (pointer to target array), rsi (pointer to source array) -> -
strcmp : rdi (pointer to target array), rsi (pointer to source array) -> ax
strcpy : rdi (pointer to target array), rsi (pointer to source array) -> -
strlen : rdi (pointer to char array) -> ax
