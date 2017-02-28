
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# Update this based on the Broadcom SDK version, 4.16L.05 -> 416050
BRCM_SDK_VERSION:=502020

PKG_SOURCE_VERSION:=ronny_merge_4.16L.05

ifneq ($(CONFIG_BCM_OPEN),y)
PKG_NAME := bcmkernel-4.1
PKG_VERSION := $(BRCM_SDK_VERSION)
PKG_RELEASE := 1
PKG_FLAGS := essential

PKG_SOURCE_URL:=git@private.inteno.se:bcmcreator
PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(BRCM_SDK_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
endif

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(BRCM_SDK_VERSION)
PKG_SOURCE_VERSION_FILE:=$(lastword $(MAKEFILE_LIST))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/image.mk
include $(INCLUDE_DIR)/kernel.mk

export CONFIG_BCM_CHIP_ID := $(subst ",,$(CONFIG_BCM_CHIP_ID))
export CONFIG_BCM_CFE_PASSWORD
export CONFIG_BCM_KERNEL_PROFILE := $(subst ",,$(CONFIG_BCM_KERNEL_PROFILE))
export CONFIG_SECURE_BOOT_CFE
export CONFIG_ARCH := $(subst ",,$(CONFIG_ARCH))


IBOARDID := $(subst ",,$(CONFIG_TARGET_IBOARDID))
BCM_BS_PROFILE := $(subst ",,$(CONFIG_BCM_KERNEL_PROFILE))

BCM_KERNEL_VERSION := 4.1.27
BCM_SDK_VERSION := bcm963xx
BCM_FS_DIR := $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs

define Package/bcmkernel/removevoice
	rm -f $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/endpointdd.ko
endef

ifeq ($(CONFIG_BCM_ENDPOINT_MODULE),y)
define Package/bcmkernel/removevoice
	echo not removing $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/endpointdd.ko
endef
endif

define Package/bcmkernel/removesound
	rm -f $(1)/lib/modules/$(BCM_KERNEL_VERSION)/snd*
	rm -f $(1)/lib/modules/$(BCM_KERNEL_VERSION)/soundcore.ko
endef

ifeq ($(BCM_USBSOUND_MODULES),y)
define Package/bcmkernel/removesound
	echo not removing $(1)/lib/modules/$(BCM_KERNEL_VERSION)/snd*
endef
endif


define Package/bcmkernel/removei2c
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/i2c*
endef

ifeq ($(CONFIG_BCM_I2C),y)
define Package/bcmkernel/removei2c
	echo not removing $(1)/lib/modules/$(BCM_KERNEL_VERSION)/i2c*
endef
endif

define Package/bcmkernel/removebluetooth
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/bluetooth.ko
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/bnep.ko
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/btusb.ko
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/rfcomm.ko
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/hci_uart.ko
endef

ifeq ($(CONFIG_BCM_BLUETOOTH),y)
define Package/bcmkernel/removebluetooth
	echo not removing $(1)/lib/modules/$(BCM_KERNEL_VERSION)/bluetooth.ko etc...
endef
endif

define Package/bcmkernel/install
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/adsl
	$(INSTALL_DIR) $(1)/etc/dsl
	$(INSTALL_DIR) $(1)/etc/wlan
	$(INSTALL_DIR) $(1)/etc/cms_entity_info.d
	$(INSTALL_DIR) $(1)/etc/modules.d

	# Install header files
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/broadcom/include/bcm963xx
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/endpt/inc
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/codec
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/casCtl/inc
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/LinuxUser
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/opensource/include/bcm963xx
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/shared/opensource/include/bcm963xx
	#$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/userspace/private/apps/vodsl/voip/inc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xchg/bos/LinuxUser
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xchg/bos/publicInc


	$(CP) -r $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/shared/opensource/include/bcm963xx/* $(STAGING_DIR)/usr/include/bcm963xx/shared/opensource/include/bcm963xx

	$(CP) -r $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/bcmdrivers/opensource/include/bcm963xx/* $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/opensource/include/bcm963xx/

	# TODO: Voice has completely changed, disable it for now
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgTypes.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgTypes.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfg.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfg.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfgCustom.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfgCustom.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgLogCfgCustom.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgLogCfgCustom.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgLog.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgLog.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/countryArchive.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/countryArchive.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgCountry.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgCountry.h

	# TODO: Voice has completely changed, disable it for now
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/casCtl/inc/casCtl.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/casCtl/inc/casCtl.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/codec/codec.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/codec/codec.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/endpt/inc/endpt.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/endpt/inc/endpt.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/endpt/inc/vrgEndpt.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/endpt/inc/vrgEndpt.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/LinuxUser/bosTypesLinuxUser.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/LinuxUser/bosTypesLinuxUser.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/userspace/private/libs/xchg/bos/LinuxUser/bosTypesLinuxUser.h $(STAGING_DIR)/usr/include/bcm963xx/xchg/bos/LinuxUser/bosTypesLinuxUser.h
                            
	cd $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/userspace/private/libs/xchg/bos/publicInc && \
		$(CP) -t $(STAGING_DIR)/usr/include/bcm963xx/xchg/bos/publicInc			\
		bosMutex.h bosSpinlock.h bosMsgQ.h bosCritSect.h bosTypes.h bosTime.h	\
		bosSem.h bosCfgCustom.h bosIpAddr.h bosTimer.h bosError.h bosLog.h		\
		bosSleep.h bosMisc.h bosCfg.h bosEvent.h bosTask.h bosUtil.h			\
		bosInit.h bosSocket.h bosFile.h

# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosMutex.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosMutex.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSpinlock.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSpinlock.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosMsgQ.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosMsgQ.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosCritSect.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosCritSect.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTypes.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTypes.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTime.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTime.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSem.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSem.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosCfgCustom.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosCfgCustom.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosIpAddr.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosIpAddr.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTimer.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTimer.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosError.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosError.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosLog.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosLog.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSleep.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSleep.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosMisc.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosMisc.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosCfg.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosCfg.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosEvent.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosEvent.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTask.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTask.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosUtil.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosUtil.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosInit.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosInit.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSocket.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSocket.h
# 	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosFile.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosFile.h

	# TODO: Voice has completely changed, disable it for now
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvSlic.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvSlic.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvApm.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvApm.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvCas.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvCas.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvTypes.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvTypes.h

	# TODO: Voice has completely changed, disable it for now
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/bcmdrivers/broadcom/include/bcm963xx/endptvoicestats.h $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/broadcom/include/bcm963xx/endptvoicestats.h
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/bcmdrivers/broadcom/include/bcm963xx/endpointdrv.h $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/broadcom/include/bcm963xx/endpointdrv.h
ifneq ($(CONFIG_BCM_OPEN),y)
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/userspace/private/apps/vodsl/voip/inc/tpProfiles.h $(STAGING_DIR)/usr/include/bcm963xx/userspace/private/apps/vodsl/voip/inc
endif
	echo "#define BCM_SDK_VERSION $(BRCM_SDK_VERSION)" > $(STAGING_DIR)/usr/include/bcm_sdk_version.h

ifneq ($(CONFIG_BCM_OPEN),y)
	# create symlink to kernel build directory
	rm -f $(BUILD_DIR)/bcmkernel
	ln -sfn $(PKG_SOURCE_SUBDIR) $(BUILD_DIR)/bcmkernel
endif


# Install binaries

# auto channel selection
	$(CP) $(BCM_FS_DIR)/bin/acs_cli $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/acsd $(1)/usr/sbin/

# tmctl - traffic manager
	$(CP) $(BCM_FS_DIR)/bin/tmctl $(1)/usr/sbin/

# bcm bridge control
	$(CP) $(BCM_FS_DIR)/bin/brctl $(1)/usr/sbin/

# broadcom busybox
	$(CP) $(BCM_FS_DIR)/bin/busybox $(1)/usr/sbin/
# taskset called by wl driver
	ln -s /usr/sbin/busybox $(1)/usr/bin/taskset


# band steering daemon
# switch between 2.4 and 5 GHz wifi
	$(CP) $(BCM_FS_DIR)/bin/bsd $(1)/usr/sbin/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_963138BGWV_),) 
# wireless control util for AC cards using dhd (offloading) module
# dhd -> dhdctl
#	$(CP) $(BCM_FS_DIR)/bin/dhd $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/dhdctl $(1)/usr/sbin/
endif

# daemon used to check bcm nvram wifi parameters 
	$(CP) $(BCM_FS_DIR)/bin/eapd $(1)/usr/sbin/

# layer 2 packet filtering (could we use openwrt?)
	$(CP) $(BCM_FS_DIR)/bin/ebtables $(1)/usr/sbin/

# ethernet control utility extended with brcm ioctl:s
	$(CP) $(BCM_FS_DIR)/bin/ethctl $(1)/usr/sbin/

# ethernet switch control utility extended with brcm ioctl:s
	$(CP) $(BCM_FS_DIR)/bin/ethswctl $(1)/usr/sbin/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_96362GWV_),)
# bcm fast packet accelerator utility
# fap -> fapctl
#	$(CP) $(BCM_FS_DIR)/bin/fap $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/fapctl $(1)/usr/sbin/
endif

# bcm flow cache utility
# fc -> fcctl
#	$(CP) $(BCM_FS_DIR)/bin/fc $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/fcctl $(1)/usr/sbin/

# brcm layer2 utility, releated to wifi, function unknown
	$(CP) $(BCM_FS_DIR)/bin/lld2d $(1)/usr/sbin/

# brcm multicast daemon
	$(CP) $(BCM_FS_DIR)/bin/mcpd $(1)/usr/sbin/

# brcm switch related utility
ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_963381GWV_96362GWV_),)
	$(CP) $(BCM_FS_DIR)/bin/mdkcmd $(1)/usr/sbin/
endif
	$(CP) $(BCM_FS_DIR)/bin/mdkshell $(1)/usr/sbin/

# wifi authentication daemon
	$(CP) $(BCM_FS_DIR)/bin/nas $(1)/usr/sbin/

# brcm nvram utility
	$(CP) $(BCM_FS_DIR)/bin/nvram $(1)/usr/sbin/

# update nvram from a file
	$(CP) $(BCM_FS_DIR)/bin/nvramUpdate $(1)/usr/sbin/

# brcm power control utility
# pwr -> pwrctl
#	$(CP) $(BCM_FS_DIR)/bin/pwr $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/pwrctl $(1)/usr/sbin/

# brcm system daemon
	$(CP) $(BCM_FS_DIR)/bin/smd $(1)/usr/sbin/

# brcm switch daemon
	$(CP) $(BCM_FS_DIR)/bin/swmdk $(1)/usr/sbin/

# unknown 
	$(CP) $(BCM_FS_DIR)/bin/tmsctl $(1)/usr/sbin/

# brcm vlan controller
	$(CP) $(BCM_FS_DIR)/bin/vlanctl $(1)/usr/sbin/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV__96362GWV_),)
# brcm BPM control utility
	$(CP) $(BCM_FS_DIR)/bin/bpmctl $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/bpm $(1)/usr/sbin/
# brcm ingress QoS control utility
	$(CP) $(BCM_FS_DIR)/bin/iqctl $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/iq $(1)/usr/sbin/
endif

# brcm wireless configuration tool
# reads from nvram and configures wifi with wlctl commands
	$(CP) $(BCM_FS_DIR)/bin/wlconf $(1)/usr/sbin/

# brcm wireless configuration utility
	$(CP) $(BCM_FS_DIR)/bin/wlctl $(1)/usr/sbin/

# brcm wps tools
	$(CP) $(BCM_FS_DIR)/bin/wps_monitor $(1)/usr/sbin/
	$(warning WPS only in closed source?)
	#$(CP) $(BCM_FS_DIR)/bin/wps_cmd $(1)/usr/sbin/

# brcm dsl control utility
# adslctl -> xdslctl
# adsl -> xdslctl
#	$(CP) $(BCM_FS_DIR)/bin/adsl $(1)/usr/sbin/
#	$(CP) $(BCM_FS_DIR)/bin/adslctl $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/xdslctl $(1)/usr/sbin/

#dsl debugging daemon
	$(CP) $(BCM_FS_DIR)/bin/dsldiagd $(1)/usr/sbin/

# brcm dsl layer2 control utility
# xtm -> xtmctl
#	$(CP) $(BCM_FS_DIR)/bin/xtm $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/bin/xtmctl $(1)/usr/sbin/

# crypto acceleration 
ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV__96362GWV_),)
	$(CP) $(BCM_FS_DIR)/bin/spuctl $(1)/usr/sbin/
	$(warning TODO: Use ipsec-tools from Iopsys instead of Broadcom?)
	#$(CP) $(BCM_FS_DIR)/bin/setkey $(1)/usr/sbin/
endif

	$(CP) $(BCM_FS_DIR)/etc/cms_entity_info.d/eid_bcm_kthreads.txt $(1)/etc/cms_entity_info.d/
	$(CP) $(BCM_FS_DIR)/etc/cms_entity_info.d/symbol_table.txt $(1)/etc/cms_entity_info.d/

	$(CP) $(BCM_FS_DIR)/etc/init.d/bcm-base-drivers.sh $(1)/lib/
	sed -i '/bcm_usb\.ko/d' $(1)/lib/bcm-base-drivers.sh
	sed -i 's|/kernel/.*/|/|' $(1)/lib/bcm-base-drivers.sh

	if [ -f $(BCM_FS_DIR)/etc/rdpa_init.sh ]; then								\
		$(CP) $(BCM_FS_DIR)/etc/rdpa_init.sh $(1)/etc/;							\
	fi


# Install libraries
	cd $(BCM_FS_DIR)/lib &&														\
		$(CP) -t $(1)/usr/lib/													\
		libcms_cli.so libcms_core.so libcms_dal.so libcms_msg.so				\
		libcms_qdm.so libebtable_broute.so libebtable_filter.so					\
		libebtable_nat.so libebtc.so libebt_ftos.so libebt_ip6.so				\
		libebt_ip.so libebt_mark_m.so libebt_mark.so libebt_skiplog.so			\
		libebt_standard.so libebt_time.so libebt_vlan.so libebt_wmm_mark.so		\
		libfcctl.so libnanoxml.so libnvram.so libpwrctl.so						\
		libtmctl.so libvlanctl.so libwlcsm.so libwlctl.so						\
		libwlupnp.so libwps.so libxdslctl.so libwlbcmcrypto.so					\
		libwlbcmshared.so libcms_util.so libbcm_crc.so libbcm_flashutil.so		\
		libatmctl.so libethswctl.so libbridgeutil.so libethctl.so				\
		libbcm_boardctl.so libbcmmcast.so
	# These libs was in v4 but not v5, what todo?
	# libsnoopctl.so libssp.so libcms_boardctl.so libwlmngr.so

	# Replace sysroot librarys with corresponding from Iopsys
	cd $(BCM_FS_DIR)/lib &&														\
		for f in libc.so libcrypt.so libdl.so libm.so libpthread.so				\
				librt.so libresolv.so; do										\
			[ -f "$(1)/lib/$$$${f}.1" ] && continue;							\
			ln -s "$$$${f}.0" "$(1)/lib/$$$${f}.1";								\
		done

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV__96362GWV_),)
	$(CP) $(BCM_FS_DIR)/lib/libfapctl.so										\
		$(BCM_FS_DIR)/lib/libspuctl.so											\
		$(BCM_FS_DIR)/lib/libiqctl.so $(1)/usr/lib/
endif

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963381GWV_),)
	$(CP) $(BCM_FS_DIR)/lib/libbcmtm.so $(1)/usr/lib/
endif

ifeq (963138BGWV,$(BCM_BS_PROFILE))
	# needed by tmctl on dg400
	$(CP) $(BCM_FS_DIR)/lib/librdpactl.so $(1)/usr/lib/
endif

	# install dsl firmware
	@echo DSL firmware does not yet work
	#$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/dsl/$(BCM_BS_PROFILE)/* $(1)/etc/dsl

	# Install kernel modules
	rm -rf $(1)/lib/modules/$(BCM_KERNEL_VERSION)/*
	$(INSTALL_DIR) $(1)/lib/modules/$(BCM_KERNEL_VERSION)/
	$(CP) $(BCM_FS_DIR)/lib/modules/$(BCM_KERNEL_VERSION)/extra	$(1)/lib/modules/$(BCM_KERNEL_VERSION)/
	$(CP) $(BCM_FS_DIR)/lib/modules/$(BCM_KERNEL_VERSION)/kernel $(1)/lib/modules/$(BCM_KERNEL_VERSION)/


	$(CP) $(BCM_FS_DIR)/etc/wlan/* $(1)/etc/wlan
	$(CP) $(BCM_FS_DIR)/etc/telephonyProfiles.d $(1)/etc/

#	rm -rf $(1)/lib/modules/$(BCM_KERNEL_VERSION)/bcm_usb.ko

	# Alternative DECT modules taken from the Natalie package and if that is not selected, no DECT modules should be loaded
	rm -f $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/dect.ko


	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/kernel/linux-*/vmlinux $(KDIR)/vmlinux.bcm.elf
	$(KERNEL_CROSS)strip --remove-section=.note --remove-section=.comment $(KDIR)/vmlinux.bcm.elf
	$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -O binary $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/kernel/linux-*/vmlinux $(KDIR)/vmlinux.bcm

	# bootloader nor
#	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_rom/bcm9$(CONFIG_BCM_CHIP_ID)_cfe.w $(KDIR)/bcm_bootloader_cfe.w

	# ram part of the bootloader for nand boot
	if [ -f $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID)ram.bin ]; then					\
		$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID)ram.bin $(KDIR)/cferam.001;	\
	elif [ -f $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID).bin ]; then					\
		$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID).bin $(KDIR)/cferam.001;		\
	fi;
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_rom/cfe$(CONFIG_BCM_CHIP_ID)_nand.v $(KDIR)
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/cfe $(KDIR)
#	dd if=$(KDIR)/vmlinux.bcm.elf of=$(KDIR)/vmlinux.bcm bs=4096 count=1
#	$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux.elf


	# install static files
	$(CP) files $(1)

	$(call Package/bcmkernel/removevoice,$(1))
	$(call Package/bcmkernel/removesound,$(1))
#	$(call Package/bcmkernel/removei2c,$(1))
endef

ifneq ($(CONFIG_BCM_OPEN),y)
ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_),) 

define Package/speedsvc
# you have to do this call
# setting the same variables to the same values do not work?
# space matters somehow!!!!!!!!!!!!!!!!!!!!
	$(call Package/bcmkernel)
	TITLE:=Speed test services
endef

define Package/speedsvc/description
	This package contains the speedsvc userspace libs/programs (description)
endef

define Package/speedsvc/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(BCM_FS_DIR)/bin/speedsvc $(1)/usr/sbin/
	$(CP) $(BCM_FS_DIR)/lib/libspdsvc.so $(1)/usr/lib/
endef

$(eval $(call BuildPackage,speedsvc))
endif
endif
