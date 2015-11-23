#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=imagetag_nand
PKG_RELEASE:=1

PKG_INSTALL:=0
PKG_BUILD_DEPENDS:=imagetag_nand/host

include $(INCLUDE_DIR)/host-build.mk
#include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define Package/imagetag_nand
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=imagetag_nand
endef
define Package/imagetag_nand/description
	lalalal lalalallaa  imagetag_nand
endef

define Build/Prepare
	echo "ImageTAG prepare"
endef
define Build/Configure
	echo "ImageTAG configure"
endef

define Build/Compile
	echo "ImageTAG compile"
endef

define Build/Install
	echo "ImageTAG instzll"
endef

define Package/imagetag_nand/install
	echo "ImageTAG installed"
endef


define my_cc
	$(HOSTCC) $(HOST_CFLAGS) -include endian.h $(HOST_STATIC_LINKING) -o $(HOST_BUILD_DIR)/bin/$(firstword $(1)) $(foreach src,$(1),src/$(src).c) $(2)
endef

define Host/Compile
	mkdir -p $(HOST_BUILD_DIR)/bin
	$(call my_cc,imagetag_nand)
endef

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/bin/* $(STAGING_DIR_HOST)/bin/
endef

$(eval $(call BuildPackage,imagetag_nand))
$(eval $(call HostBuild))

