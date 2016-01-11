#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=brcm-base-files

PKG_VERSION:=1.0
PKG_SOURCE_URL:=git@iopsys.inteno.se:brcm-base-files.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=646f2b8620ddbea4a4409b7bad0cb1a0edabb428

PKG_RELEASE=$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

######################################


define Package/brcm-base-files/install
	$(CP) $(PKG_BUILD_DIR)/files/* $(1)/
endef

define Package/brcm-base-files
	SECTION:=base-files
	CATEGORY:=STK base files
	TITLE:=brcm-base-files
endef



######################################

$(eval $(call BuildPackage,brcm-base-files))



