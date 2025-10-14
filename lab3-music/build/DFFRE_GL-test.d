#=========================================================================
# Makefile dependency fragment
#=========================================================================

DFFRE_GL-test: \
  DFFRE_GL-test.v \
  ece2300-test.v \
  DFFRE_GL.v \
  DFFRE-test-cases.v \
  DFF_GL.v \
  Mux2_1b_GL.v \
  DLatch_GL.v \

DFFRE_GL-test.d: \
  DFFRE_GL-test.v \
  ece2300-test.v \
  DFFRE_GL.v \
  DFFRE-test-cases.v \
  DFF_GL.v \
  Mux2_1b_GL.v \
  DLatch_GL.v \

ece2300-test.v:

DFFRE_GL.v:

DFFRE-test-cases.v:

DFF_GL.v:

Mux2_1b_GL.v:

DLatch_GL.v:

