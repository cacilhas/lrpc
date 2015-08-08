LUAJIT= luajit
SHARE_DIR := $(shell $(LUAJIT) find_lua_path.lua)
LUA := LUA_PATH="./?.lua;./?/init.lua;$$LUA_PATH" $(LUAJIT)
CC= moonc
MD= mkdir -p
DEST= $(SHARE_DIR)/lrpc
INSTALL= cp -rf
RM= rm -rf

SRC= $(wildcard lrpc/*.moon)
TEST_SRC= $(wildcard tests/*.moon)
TARGET= $(SRC:.moon=.lua)
TESTS= $(TEST_SRC:.moon=.lua)

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
	$(RM) $(TARGET) $(TESTS)


.PHONY: test
test: $(TARGET) $(TESTS)
	$(LUA) tests/server.lua &
	@sleep .1
	$(LUA) tests/client.lua
	@killall $(LUAJIT)
