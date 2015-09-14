################################################################################
#
# lzma
#
################################################################################

LZMA_VERSION = 4.65
LZMA_SOURCE = lzma-$(LZMA_VERSION).tar.bz2
LZMA_SITE = https://users.atomshare.net/~zlmch

LZMA_ALONE_DIR = $(HOST_LZMA_BUILDDIR)/CPP/7zip/Compress/LZMA_Alone

define HOST_LZMA_BUILD_CMDS
	$(MAKE) -C $(LZMA_ALONE_DIR) -f makefile.gcc
endef

define HOST_LZMA_INSTALL_CMDS
	$(INSTALL) $(LZMA_ALONE_DIR)/lzma $(HOST_DIR)/usr/bin/lzma_alone
endef

$(eval $(host-generic-package))
