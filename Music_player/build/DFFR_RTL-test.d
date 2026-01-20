#=========================================================================
# Makefile dependency fragment
#=========================================================================

DFFR_RTL-test: \
  DFFR_RTL-test.v \
  ece2300-test.v \
  DFFR_RTL.v \
  DFFR-test-cases.v \

DFFR_RTL-test.d: \
  DFFR_RTL-test.v \
  ece2300-test.v \
  DFFR_RTL.v \
  DFFR-test-cases.v \

ece2300-test.v:

DFFR_RTL.v:

DFFR-test-cases.v:

