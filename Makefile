# tool macros
CXX := g++
CXXFLAGS :=
DBGFLAGS := -g
CCOBJFLAGS := $(CXXFLAGS) -c

# path macros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := debug
RES_PATH := res

# compile macros
TARGET_NAME := PasswordSeeker
ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

RES := $(RES_PATH)/*.res

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# clean files list
DISTCLEAN_LIST := $(OBJ_PATH)
CLEAN_LIST := .\$(BIN_PATH) \
			  .\$(DBG_PATH) \
			  .\$(DISTCLEAN_LIST)

# default rule
default: clean all

# non-phony targets
$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJ) $(RES)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CXX) $(CCOBJFLAGS) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CXX) $(CCOBJFLAGS) $(DBGFLAGS) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CXX) $(CXXFLAGS) $(DBGFLAGS) $(OBJ_DEBUG) -o $@

.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo Going to delete: $(CLEAN_LIST)
	@del /f /q $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(CLEAN_LIST)
	ifeq ($(OS),Windows_NT)
	@del /f $(CLEAN_LIST)
	else
	@rm -f $(DISTCLEAN_LIST)
	endif

.PHONY: launch
launch:
	$(BIN_PATH)/$(TARGET_NAME)