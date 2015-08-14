

ifeq ($(BR2_i386),y)
NIM_CPU = i386
else ifeq ($(BR2_x86_64),y)
NIM_CPU = amd64
else ifeq ($(BR2_mips),y)
NIM_CPU = mips
else ifeq ($(BR2_mipsel),y)
NIM_CPU = mipsel
else ifeq ($(BR2_arm),y)
NIM_CPU = arm
endif


################################################################################
# inner-nim-package -- defines how the configuration, compilation
# and installation of a Nim package should be done, implements a
# few hooks to tune the build process and calls the generic package
# infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-nim-package

$(2)_DEPENDENCIES += host-nim

ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
	    for name in $$($$(PKG)_NIM_BINARIES); do \
	      PATH="$$(HOST_DIR)/usr/bin:$$$$PATH" \
		  $$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
	      $$(HOST_DIR)/usr/bin/nim compile -d:useFork --cpu:$$(NIM_CPU) --os:linux --parallelBuild:1 $$$$name; done)
endef
endif

ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	for name in $$($$(PKG)_NIM_BINARIES); do $$(INSTALL) $$($$(PKG)_BUILDDIR)/bin/"$$$$name" $$(TARGET_DIR)/usr/bin; done
endef
endif

$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef



nim-package = $(call inner-nim-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
