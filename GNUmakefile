# TEMPLATE FOR MAKEFILE TO USE IN FRAMA-C/EVA CASE STUDIES

# DO NOT EDIT THE LINES BETWEEN THE '#'S

###############################################################################
# Improves analysis time, at the cost of extra memory usage
export FRAMA_C_MEMORY_FOOTPRINT = 8
#
# frama-c-path.mk contains variables which are specific to each
# user and should not be versioned, such as the path to the
# frama-c binaries (e.g. FRAMAC and FRAMAC_GUI).
# It is an optional include, unnecessary if frama-c is in the PATH
-include frama-c-path.mk
#
# FRAMAC is defined in frama-c-path.mk when it is included, so the
# line below will be safely ignored if this is the case
FRAMAC ?= frama-c
#
# frama-c.mk contains the main rules and targets
-include $(shell $(FRAMAC)-config -print-share-path)/analysis-scripts/frama-c.mk
#
###############################################################################

# EDIT VARIABLES AND TARGETS BELOW AS NEEDED
# The flags below are only suggestions to use with Eva, and can be removed

# (Optional) preprocessing flags, usually handled by -json-compilation-database
CPPFLAGS    += \
  -Icommon \

# (Optional) Frama-C general flags (parsing and kernel)
FCFLAGS     += \
  -machdep x86_32 \
  -kernel-warn-key annot:missing-spec=abort \
  -kernel-warn-key typing:implicit-function-declaration=abort \

# (Optional) Eva-specific flags
EVAFLAGS    += \
  -eva-warn-key builtins:missing-spec=abort \
  -eva-precision 3 \

# excludes files with recursive functions
filter-out-substring = $(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
SRCS:=$(sort $(call filter-out-substring,leak,$(call filter-out-substring,recursion,$(wildcard base/*.c */*/*.c))))

GOOD_TARGETS:=$(foreach s,$(SRCS),$(subst /,_,$(s:%.c=%))_good.eva)
BAD_TARGETS:=$(foreach s,$(SRCS),$(subst /,_,$(s:%.c=%))_bad.eva)
TARGETS:=$(GOOD_TARGETS) $(BAD_TARGETS)

all: $(TARGETS)

define generate-parse-rules =
  $(subst /,_,$(1:%.c=%))_good.parse: $(if $(findstring cross_file,$(1)),common/common.c,) $(1)
  $(subst /,_,$(1:%.c=%))_good.parse: CPPFLAGS+="-DNO_BUG"
  $(subst /,_,$(1:%.c=%))_bad.parse: $(if $(findstring cross_file,$(1)),common/common.c,) $(1)

  $(subst /,_,$(1:%.c=%))_good.eva/eval.txt: $(subst /,_,$(1:%.c=%))_good.eva evaluate_case.sh
	./evaluate_case.sh good $$</alarms.csv > $$</eval.txt
  $(subst /,_,$(1:%.c=%))_bad.eva/eval.txt: $(subst /,_,$(1:%.c=%))_bad.eva evaluate_case.sh
	./evaluate_case.sh bad $$</alarms.csv > $$</eval.txt
endef
$(foreach s,$(SRCS),$(eval $(call generate-parse-rules,$(s))))

eval_summary.txt: $(addsuffix /eval.txt, $(TARGETS))
	cat $^ > eval_summary.txt

evaluate: eval_summary.txt
.PHONY: eval_summary.txt

# The following targets are optional and provided for convenience only
parse: $(TARGETS:%.eva=%.parse)

# Run 'make <TARGET>.eva.loop' to obtain a .loop file, fine-tune it by hand,
# then rename it to <TARGET>.slevel to prevent it from being overwritten.
# If such file exists, use it to define per-function slevel values.
ifneq (,$(wildcard $(MAIN_TARGET).slevel))
$(MAIN_TARGET).eva: \
  EVAFLAGS += $(shell cat $(MAIN_TARGET).slevel | tr -d '\n\\')
endif

########## INFER RUN

INFER = infer run

# excludes files with recursive functions

INFER_GOOD_TARGETS:=$(foreach s,$(SRCS),$(subst /,_,$(s:%.c=%))_good.infer)
INFER_BAD_TARGETS:=$(foreach s,$(SRCS),$(subst /,_,$(s:%.c=%))_bad.infer)
INFER_TARGETS:=$(INFER_GOOD_TARGETS) $(INFER_BAD_TARGETS)

define generate-infer-rules =
  $(subst /,_,$(1:%.c=%))_good.infer: $(if $(findstring cross_file,$(1)),common/common.c,) $(1)
	$(INFER) -o $$@ -- clang -DNO_BUG $(CPPFLAGS) $$^

  $(subst /,_,$(1:%.c=%))_bad.infer: $(if $(findstring cross_file,$(1)),common/common.c,) $(1)
	$(INFER) -o $$@ -- clang $(CPPFLAGS) $$^

  $(subst /,_,$(1:%.c=%))_good.infer/eval.txt: $(subst /,_,$(1:%.c=%))_good.infer infer_evaluate_case.sh
	./infer_evaluate_case.sh good $$</bugs.txt > $$</eval.txt

  $(subst /,_,$(1:%.c=%))_bad.infer/eval.txt: $(subst /,_,$(1:%.c=%))_bad.infer infer_evaluate_case.sh
	./infer_evaluate_case.sh bad $$</bugs.txt > $$</eval.txt
endef

$(foreach s,$(SRCS),$(eval $(call generate-infer-rules,$(s))))

infer_eval_sumup.txt: $(addsuffix /eval.txt, $(INFER_TARGETS))
	cat $^ > infer_eval_sumup.txt

infer_evaluate: infer_eval_sumup.txt
.PHONY: infer_eval_sumup.txt

good: $(INFER_GOOD_TARGETS)

bad: $(INFER_BAD_TARGETS)

fclean:
	@rm -rf *_good.infer
	@rm -rf *_bad.infer
	@rm -rf a.out
	@rm -rf infer-out

