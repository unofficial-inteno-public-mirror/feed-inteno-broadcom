
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# Update this based on the Broadcom SDK version, 4.16L.05 -> 416050
BRCM_SDK_VERSION:=416050

PKG_SOURCE_VERSION:=c00f40273d4654796b17a89f3df4f3f1cd691863

ifneq ($(CONFIG_BCM_OPEN),y)
PKG_NAME:=bcmkernel-3.4
PKG_VERSION:=$(BRCM_SDK_VERSION)
PKG_RELEASE:=1

PKG_SOURCE_URL:=git@private.inteno.se:bcmkernel
PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(BRCM_SDK_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
endif

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(BRCM_SDK_VERSION)
PKG_SOURCE_VERSION_FILE:=$(lastword $(MAKEFILE_LIST))

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/image.mk
include $(INCLUDE_DIR)/kernel.mk

export CONFIG_BCM_CHIP_ID
export CONFIG_BCM_CFE_PASSWORD
export CONFIG_BCM_KERNEL_PROFILE
export CONFIG_SECURE_BOOT_CFE


IBOARDID = $(shell echo $(CONFIG_TARGET_IBOARDID) |sed s/\"//g)
BCM_BS_PROFILE = $(shell echo $(CONFIG_BCM_KERNEL_PROFILE) | sed s/\"//g)

BCM_KERNEL_VERSION:=3.4.11-rt19
BCM_SDK_VERSION:=bcm963xx
RSTRIP:=true
BCM_BIN_DIR=$(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/bin
BCM_LIB_DIR=$(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/lib

define Package/bcmkernel/removevoice
	touch $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/endpointdd.ko
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/endpointdd.ko
endef

ifeq ($(CONFIG_BCM_ENDPOINT_MODULE),y)
define Package/bcmkernel/removevoice
	echo not removing $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/endpointdd.ko
endef
endif

define Package/bcmkernel/removesound
	touch $(1)/lib/modules/$(BCM_KERNEL_VERSION)/snd
	touch $(1)/lib/modules/$(BCM_KERNEL_VERSION)/soundcore.ko
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/snd*
	rm $(1)/lib/modules/$(BCM_KERNEL_VERSION)/soundcore.ko
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
	$(INSTALL_DIR) $(1)/etc/init.d

	# Install header files
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/broadcom/include/bcm963xx
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/endpt/inc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/codec
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/casCtl/inc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/LinuxUser
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/opensource/include/bcm963xx
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/shared/opensource/include/bcm963xx
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include/bcm963xx/userspace/private/apps/vodsl/voip/inc


	$(CP) -r $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/shared/opensource/include/bcm963xx/* $(STAGING_DIR)/usr/include/bcm963xx/shared/opensource/include/bcm963xx

	$(CP) -r $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/bcmdrivers/opensource/include/bcm963xx/* $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/opensource/include/bcm963xx/

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgTypes.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgTypes.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfg.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfg.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfgCustom.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgCountryCfgCustom.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgLogCfgCustom.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgLogCfgCustom.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgLog.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgLog.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/countryArchive.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/countryArchive.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/inc/vrgCountry.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/inc/vrgCountry.h

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/casCtl/inc/casCtl.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/casCtl/inc/casCtl.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/codec/codec.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/codec/codec.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/endpt/inc/endpt.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/endpt/inc/endpt.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/voice_res_gw/endpt/inc/vrgEndpt.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/voice_res_gw/endpt/inc/vrgEndpt.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/LinuxUser/bosTypesLinuxUser.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/LinuxUser/bosTypesLinuxUser.h

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosMutex.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosMutex.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSpinlock.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSpinlock.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosMsgQ.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosMsgQ.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosCritSect.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosCritSect.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTypes.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTypes.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTime.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTime.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSem.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSem.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosCfgCustom.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosCfgCustom.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosIpAddr.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosIpAddr.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTimer.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTimer.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosError.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosError.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosLog.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosLog.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSleep.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSleep.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosMisc.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosMisc.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosCfg.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosCfg.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosEvent.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosEvent.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosTask.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosTask.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosUtil.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosUtil.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosInit.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosInit.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosSocket.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosSocket.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_common/bos/publicInc/bosFile.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_common/bos/publicInc/bosFile.h

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvSlic.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvSlic.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvApm.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvApm.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvCas.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvCas.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/xChange/dslx_common/xchg_drivers/inc/xdrvTypes.h $(STAGING_DIR)/usr/include/bcm963xx/xChange/dslx_common/xchg_drivers/inc/xdrvTypes.h

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/bcmdrivers/broadcom/include/bcm963xx/endptvoicestats.h $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/broadcom/include/bcm963xx/endptvoicestats.h
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/bcmdrivers/broadcom/include/bcm963xx/endpointdrv.h $(STAGING_DIR)/usr/include/bcm963xx/bcmdrivers/broadcom/include/bcm963xx/endpointdrv.h
ifneq ($(CONFIG_BCM_OPEN),y)
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/userspace/private/apps/vodsl/voip/inc/tpProfiles.h $(STAGING_DIR)/usr/include/bcm963xx/userspace/private/apps/vodsl/voip/inc
endif
	echo "#define BCM_SDK_VERSION $(BRCM_SDK_VERSION)" > $(STAGING_DIR)/usr/include/bcm_sdk_version.h

ifneq ($(CONFIG_BCM_OPEN),y)
	# create symlink to kernel build directory
	rm -f $(BUILD_DIR)/bcmkernel
	ln -sfn $(PKG_SOURCE_SUBDIR) $(BUILD_DIR)/bcmkernel
endif


# Install binaries

# auto channel selection
	$(CP) $(BCM_BIN_DIR)/acs_cli $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/acsd $(1)/usr/sbin/

# tmctl - traffic manager
	$(CP) $(BCM_BIN_DIR)/tmctl $(1)/usr/sbin/

# bcm bridge control
	$(CP) $(BCM_BIN_DIR)/brctl $(1)/usr/sbin/

# broadcom busybox
	$(CP) $(BCM_BIN_DIR)/busybox $(1)/usr/sbin/
# taskset called by wl driver
	ln -s /usr/sbin/busybox $(1)/usr/bin/taskset


# band steering daemon
# switch between 2.4 and 5 GHz wifi
	$(CP) $(BCM_BIN_DIR)/bsd $(1)/usr/sbin/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_963138BGWV_),) 
# wireless control util for AC cards using dhd (offloading) module
# dhd -> dhdctl
#	$(CP) $(BCM_BIN_DIR)/dhd $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/dhdctl $(1)/usr/sbin/
endif

# daemon used to check bcm nvram wifi parameters 
	$(CP) $(BCM_BIN_DIR)/eapd $(1)/usr/sbin/

# layer 2 packet filtering (could we use openwrt?)
	$(CP) $(BCM_BIN_DIR)/ebtables $(1)/usr/sbin/

# ethernet control utility extended with brcm ioctl:s
	$(CP) $(BCM_BIN_DIR)/ethctl $(1)/usr/sbin/

# ethernet switch control utility extended with brcm ioctl:s
	$(CP) $(BCM_BIN_DIR)/ethswctl $(1)/usr/sbin/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_96362GWV_),)
# bcm fast packet accelerator utility
# fap -> fapctl
#	$(CP) $(BCM_BIN_DIR)/fap $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/fapctl $(1)/usr/sbin/
endif

# bcm flow cache utility
# fc -> fcctl
#	$(CP) $(BCM_BIN_DIR)/fc $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/fcctl $(1)/usr/sbin/

# brcm layer2 utility, releated to wifi, function unknown
	$(CP) $(BCM_BIN_DIR)/lld2d $(1)/usr/sbin/

# brcm multicast daemon
	$(CP) $(BCM_BIN_DIR)/mcpd $(1)/usr/sbin/

# brcm switch related utility
ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV_963381GWV_96362GWV_),)
	$(CP) $(BCM_BIN_DIR)/mdkcmd $(1)/usr/sbin/
endif
	$(CP) $(BCM_BIN_DIR)/mdkshell $(1)/usr/sbin/

# wifi authentication daemon
	$(CP) $(BCM_BIN_DIR)/nas $(1)/usr/sbin/

# brcm nvram utility
	$(CP) $(BCM_BIN_DIR)/nvram $(1)/usr/sbin/

# update nvram from a file
	$(CP) $(BCM_BIN_DIR)/nvramUpdate $(1)/usr/sbin/

# brcm power control utility
# pwr -> pwrctl
#	$(CP) $(BCM_BIN_DIR)/pwr $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/pwrctl $(1)/usr/sbin/

# brcm system daemon
	$(CP) $(BCM_BIN_DIR)/smd $(1)/usr/sbin/

# brcm switch daemon
	$(CP) $(BCM_BIN_DIR)/swmdk $(1)/usr/sbin/

# unknown 
	$(CP) $(BCM_BIN_DIR)/tmsctl $(1)/usr/sbin/

# brcm vlan controller
	$(CP) $(BCM_BIN_DIR)/vlanctl $(1)/usr/sbin/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV__96362GWV_),)
# brcm BPM control utility
	$(CP) $(BCM_BIN_DIR)/bpmctl $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/bpm $(1)/usr/sbin/
# brcm ingress QoS control utility
	$(CP) $(BCM_BIN_DIR)/iqctl $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/iq $(1)/usr/sbin/
endif

# brcm wireless configuration tool
# reads from nvram and configures wifi with wlctl commands
	$(CP) $(BCM_BIN_DIR)/wlconf $(1)/usr/sbin/

# brcm wireless configuration utility
	$(CP) $(BCM_BIN_DIR)/wlctl $(1)/usr/sbin/

# brcm wps tools
	$(CP) $(BCM_BIN_DIR)/wps_monitor $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/wps_cmd $(1)/usr/sbin/

# brcm dsl control utility
# adslctl -> xdslctl
# adsl -> xdslctl
#	$(CP) $(BCM_BIN_DIR)/adsl $(1)/usr/sbin/
#	$(CP) $(BCM_BIN_DIR)/adslctl $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/xdslctl $(1)/usr/sbin/

#dsl debugging daemon
	$(CP) $(BCM_BIN_DIR)/dsldiagd $(1)/usr/sbin/

# brcm dsl layer2 control utility
# xtm -> xtmctl
#	$(CP) $(BCM_BIN_DIR)/xtm $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/xtmctl $(1)/usr/sbin/

# crypto acceleration 
ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV__96362GWV_),)
	$(CP) $(BCM_BIN_DIR)/spuctl $(1)/usr/sbin/
	$(CP) $(BCM_BIN_DIR)/setkey $(1)/usr/sbin/

endif

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/cms_entity_info.d/eid_bcm_kthreads.txt	$(1)/etc/cms_entity_info.d/
	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/cms_entity_info.d/symbol_table.txt		$(1)/etc/cms_entity_info.d/

	$(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/init.d/bcm-base-drivers.sh			$(1)/lib/
	sed -i '/bcm_usb\.ko/d' $(1)/lib/bcm-base-drivers.sh
	sed -i 's|/kernel/.*/|/|' $(1)/lib/bcm-base-drivers.sh

	if [ -a $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/rdpa_init.sh ]; then $(CP) $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/rdpa_init.sh $(1)/etc/; fi;


# Install libraries
	$(CP) $(BCM_LIB_DIR)/libcms_cli.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libcms_core.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libcms_dal.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libcms_msg.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libcms_qdm.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebtable_broute.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebtable_filter.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebtable_nat.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebtc.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_ftos.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_ip6.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_ip.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_mark_m.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_mark.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_skiplog.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_standard.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_time.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_vlan.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libebt_wmm_mark.so $(1)/usr/lib/
ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963268GWV__96362GWV_),)
	$(CP) $(BCM_LIB_DIR)/libfapctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libspuctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libresolv.so.0 $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libiqctl.so $(1)/usr/lib/
endif
	$(CP) $(BCM_LIB_DIR)/libfcctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libnanoxml.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libnvram.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libpwrctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libsnoopctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libssp.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libtmctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libvlanctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwlcsm.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwlctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwlupnp.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwps.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libxdslctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwlbcmcrypto.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwlbcmshared.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libcms_util.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libbcm_crc.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libbcm_flashutil.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libcms_boardctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libatmctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libethswctl.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libwlmngr.so $(1)/usr/lib/
	$(CP) $(BCM_LIB_DIR)/libbridgeutil.so $(1)/usr/lib/

ifneq ($(findstring _$(strip $(BCM_BS_PROFILE))_,_963381GWV_),)
	$(CP) $(BCM_LIB_DIR)/libbcmtm.so $(1)/usr/lib/
endif

ifeq (963138BGWV,$(BCM_BS_PROFILE))
	# needed by tmctl on dg400
	$(CP) $(BCM_LIB_DIR)/librdpactl.so $(1)/usr/lib/
endif

	# install dsl firmware
	cp $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/dsl/$(BCM_BS_PROFILE)/* $(1)/etc/dsl

	# Install kernel modules
	rm -rf $(1)/lib/modules/$(BCM_KERNEL_VERSION)/*
	mkdir -p $(1)/lib/modules/$(BCM_KERNEL_VERSION)/
	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/lib/modules/$(BCM_KERNEL_VERSION)/extra	$(1)/lib/modules/$(BCM_KERNEL_VERSION)/
	#cp -r $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/lib/modules/$(BCM_KERNEL_VERSION)/kernel	$(1)/lib/modules/$(BCM_KERNEL_VERSION)/
	find $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/lib/modules/$(BCM_KERNEL_VERSION)/kernel/ -name *.ko -exec cp {} $(1)/lib/modules/$(BCM_KERNEL_VERSION)/ \;


	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/wlan/*			$(1)/etc/wlan
	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/$(BCM_BS_PROFILE)/fs/etc/telephonyProfiles.d		$(1)/etc/

#	rm -rf $(1)/lib/modules/$(BCM_KERNEL_VERSION)/bcm_usb.ko

	# Alternative DECT modules taken from the Natalie package and if that is not selected, no DECT modules should be loaded
	rm -f $(1)/lib/modules/$(BCM_KERNEL_VERSION)/extra/dect.ko


	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/kernel/linux-3.4rt/vmlinux $(KDIR)/vmlinux.bcm.elf
	$(KERNEL_CROSS)strip --remove-section=.note --remove-section=.comment $(KDIR)/vmlinux.bcm.elf
	$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -O binary $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/kernel/linux-3.4rt/vmlinux $(KDIR)/vmlinux.bcm

	# bootloader nor
#	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_rom/bcm9$(CONFIG_BCM_CHIP_ID)_cfe.w $(KDIR)/bcm_bootloader_cfe.w

	# ram part of the bootloader for nand boot
	if [ -a $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID).bin ]; then cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID).bin $(KDIR)/cferam.001; fi;
	if [ -a $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID)ram.bin ]; then cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_ram/cfe$(CONFIG_BCM_CHIP_ID)ram.bin $(KDIR)/cferam.001; fi;
	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/cfe/build/broadcom/bcm63xx_rom/cfe$(CONFIG_BCM_CHIP_ID)_nand.v $(KDIR)/cfe$(CONFIG_BCM_CHIP_ID)_nand.v
	cp -R $(PKG_BUILD_DIR)/$(BCM_SDK_VERSION)/targets/cfe/ $(KDIR)/cfe
#	dd if=$(KDIR)/vmlinux.bcm.elf of=$(KDIR)/vmlinux.bcm bs=4096 count=1
#	$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux.elf


	# install /etc/modules.d/ files
	$(CP) ./files/etc/modules.d/* $(1)/etc/modules.d/

	# install /etc/init.d/ files
	$(CP) ./files/etc/init.d/* $(1)/etc/init.d/

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
	$(CP) $(BCM_BIN_DIR)/speedsvc $(1)/usr/sbin/
	$(CP) $(BCM_LIB_DIR)/libspdsvc.so $(1)/usr/lib/
endef

$(eval $(call BuildPackage,speedsvc))
endif
endif
