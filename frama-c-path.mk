FRAMAC_DIR=../frama-c/build/bin
ifeq ($(wildcard $(FRAMAC_DIR)),)
# Frama-C not installed locally; using the version in the PATH
else
FRAMAC=$(FRAMAC_DIR)/frama-c
FRAMAC_GUI=$(FRAMAC_DIR)/frama-c-gui
FRAMAC_CONFIG=$(FRAMAC_DIR)/frama-c-config
endif
