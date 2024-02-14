CC		:= clang
CFLAGS	=
LDFLAGS	= -lcrypto -ldxp -lmagic -lssl
OUT		:= server

.PHONY:	all clean .FORCE

all: clean $(OUT)

%: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	@rm -rf $(OUT)
