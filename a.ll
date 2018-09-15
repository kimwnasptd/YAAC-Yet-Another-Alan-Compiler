; ModuleID = '-I'm really happy right now. -Me too <3'
source_filename = "<string>"

declare void @writeInteger(i32)

declare void @writeByte(i8)

declare void @writeChar(i8)

declare void @writeString(i8*)

declare i32 @readInteger()

declare i8 @readByte()

declare i8 @readChar()

declare void @readString(i32, i8*)

declare i32 @strlen(i8*)

declare i32 @strcmp(i8*, i8*)

declare void @strcpy(i8*, i8*)

declare void @strcat(i8*, i8*)

declare i32 @extend(i8)

declare i8 @shrink(i32)

define void @hello() {
entry:
  %0 = alloca [13 x i8]
  store [13 x i8] c"Hello World!\00", [13 x i8]* %0
  %1 = bitcast [13 x i8]* %0 to i8*
  call void @writeString(i8* %1)
  ret void
}

