################################################################################
#
# netd
#
################################################################################

NETD_VERSION = d34d30709f173522e4cdf9d6cfbef54f118215b9
NETD_SITE = https://github.com/zielmicha/netd
NETD_SITE_METHOD = git

NETD_NIM_BINARIES = netd

$(eval $(nim-package))
