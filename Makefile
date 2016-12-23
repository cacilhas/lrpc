LUAJIT= luajit
SHARE_DIR := $(shell $(LUAJIT) find_lua_path.lua)
LUAPATH := LUA_PATH="./?.lua;./?/init.lua;$$LUA_PATH"
MOON= moon
CC= moonc
MD= mkdir -p
DEST= $(SHARE_DIR)/lrpc
INSTALL= cp -rf
RM= rm -rf

SRC= $(wildcard lrpc/*.moon)
TARGET= $(SRC:.moon=.lua)

#-------------------------------------------------------------------------------
all: $(TARGET)


%.lua: %.moon
	$(CC) $<


$(DEST):
	$(MD) $(DEST)


.PHONY: install
install: $(TARGET) $(DEST)
	$(INSTALL) $?


.PHONY: uninstall
uninstall:
	$(RM) $(DEST)


.PHONY: clean
clean:
	$(RM) $(TARGET)


.PHONY: test
test: $(TARGET) server.pid
	$(LUAPATH) $(MOON) tests/client.moon
	@kill `cat server.pid` && $(RM) server.pid


server.pid: $(TARGET)
	$(LUAPATH) $(MOON) tests/server.moon
	@sleep .1