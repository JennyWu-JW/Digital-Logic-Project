#=========================================================================
# Makefile dependency fragment
#=========================================================================

AdderRippleCarry_8b_GL-test: \
  AdderRippleCarry_8b_GL-test.v \
  ece2300-test.v \
  AdderRippleCarry_8b_GL.v \
  AdderRippleCarry_4b_GL.v \
  FullAdder_GL.v \

AdderRippleCarry_8b_GL-test.d: \
  AdderRippleCarry_8b_GL-test.v \
  ece2300-test.v \
  AdderRippleCarry_8b_GL.v \
  AdderRippleCarry_4b_GL.v \
  FullAdder_GL.v \

ece2300-test.v:

AdderRippleCarry_8b_GL.v:

AdderRippleCarry_4b_GL.v:

FullAdder_GL.v:

