#
# Primary/common bcmkernel makefile for all versions of Broadcom SDKs
#

include $(TOPDIR)/rules.mk

define Package/bcmkernel
  SECTION:=net
  CATEGORY:=Base system
  TITLE:=Broadcom sdk 3.4 kernel
  URL:=
  MENU:=1
  DEPENDS:=+libpthread +libopenssl
endef

define Package/bcmkernel/description
	Broadcom kernel and userspace, compiled with the broadcom supplied tool-chain.
endef

define Package/bcmkernel/config
	source "$(SOURCE)/Config.in"
endef

# Include SDK version specific makefile based on config selection
ifeq ($(CONFIG_ARCH),)
-include $(TOPDIR)/.config
endif

ifeq ($(CONFIG_BRCM_SDK_VER_416040),y)
include ./416040.mk

else ifeq ($(CONFIG_BRCM_SDK_VER_416050),y)
include ./416050.mk

else
# Make 'make menuconfig' work even though no SDK version specified
PKG_VERSION:=none
include $(INCLUDE_DIR)/package.mk
endif

ifeq ($(CONFIG_BCM_OPEN),y)
BRCM_KERNEL_PROFILE=$(shell echo $(CONFIG_BCM_KERNEL_PROFILE) | sed s/\"//g)
TARGET_VERSION=$(shell echo $(CONFIG_TARGET_VERSION) | sed s/\"//g)
TARGET_IBOARDID=$(shell echo $(CONFIG_TARGET_IBOARDID) | sed s/\"//g)

PKG_NAME:=bcmopen
PKG_VERSION:=consumer

PKG_SOURCE:=$(PKG_NAME)-$(BRCM_KERNEL_PROFILE)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_URL:=http://iopsys.inteno.se/iopsys/consumer/

define Build/Prepare
	tar -xzv -C $(BUILD_DIR)/ -f $(TOPDIR)/dl/$(PKG_SOURCE) >/dev/null
	rm -f $(BUILD_DIR)/bcmkernel
	ln -sfn $(PKG_NAME)-$(PKG_VERSION) $(BUILD_DIR)/bcmkernel
endef
endif

# hack to be able to compile just the userspace part.
# TOPDIR=$PWD  make -C package/bcmkernel userspace
userspace:
	$(call Build/Compile/Default, userspace)

$(eval $(call BuildPackage,bcmkernel))

