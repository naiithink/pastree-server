CC		:= clang
CFLAGS	=
LDFLAGS	= -lcrypto -lmagic -lssl
OUT		:= server

.PHONY:	all clean .FORCE

all: clean $(OUT)

%: %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

clean:
	@rm -rf $(OUT)
