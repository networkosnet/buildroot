################################################################################
#
# Nim
#
################################################################################

# Nim language http://nim-lang.org

NIM_VERSION = 0.11.3-pre-bb2aa24c
NIM_SOURCE = nim-$(NIM_VERSION).tar.xz
NIM_SITE = https://users.atomshare.net/~zlmch/nim/
NIM_LICENSE = MIT
NIM_LICENSE_FILE = copying.txt

define HOST_NIM_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_NIM_INSTALL_CMDS
	( cd $(@D) && ./install.sh $(HOST_DIR)/usr/lib/ && ln -sf ../lib/nim/bin/nim $(HOST_DIR)/usr/bin/nim )
	$(INSTALL) -m 644 package/nim/nim.cfg $(HOST_DIR)/usr/lib/nim/config/nim.cfg
endef

$(eval $(host-generic-package))
