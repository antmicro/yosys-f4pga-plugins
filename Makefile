PLUGIN_LIST := fasm xdc params sdc ql-iob design_introspection integrateinv ql-qlf-k4n8 uhdm
PLUGINS := $(foreach plugin,$(PLUGIN_LIST),$(plugin).so)
PLUGINS_INSTALL := $(foreach plugin,$(PLUGIN_LIST),install_$(plugin))
PLUGINS_CLEAN := $(foreach plugin,$(PLUGIN_LIST),clean_$(plugin))
PLUGINS_TEST := $(foreach plugin,$(PLUGIN_LIST),test_$(plugin))

all: plugins

define install_plugin =
$(1).so:
	$$(MAKE) -C $(1)-plugin $$@

install_$(1):
	$$(MAKE) -C $(1)-plugin install

clean_$(1):
	$$(MAKE) -C $(1)-plugin clean

test_$(1):
	$$(MAKE) -C $(1)-plugin test
endef

$(foreach plugin,$(PLUGIN_LIST),$(eval $(call install_plugin,$(plugin))))

plugins: $(PLUGINS)

install: $(PLUGINS_INSTALL)

test: $(PLUGINS_TEST)

clean: $(PLUGINS_CLEAN)

CLANG_FORMAT ?= clang-format-5.0
format:
	find . -name \*.cc -and -not -path './third_party/*' -print0 | xargs -0 -P $$(nproc) ${CLANG_FORMAT} -style=file -i
	find . -name \*.h -and -not -path './third_party/*' -print0 | xargs -0 -P $$(nproc) ${CLANG_FORMAT} -style=file -i
