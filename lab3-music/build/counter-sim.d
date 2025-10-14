#=========================================================================
# Makefile dependency fragment
#=========================================================================

counter-sim: \
  counter-sim.v \
  Counter_8b_RTL.v \
  Display_GL.v \
  Register_8b_RTL.v \
  BinaryToBinCodedDec_GL.v \
  BinaryToSevenSeg_GL.v \

counter-sim.d: \
  counter-sim.v \
  Counter_8b_RTL.v \
  Display_GL.v \
  Register_8b_RTL.v \
  BinaryToBinCodedDec_GL.v \
  BinaryToSevenSeg_GL.v \

Counter_8b_RTL.v:

Display_GL.v:

Register_8b_RTL.v:

BinaryToBinCodedDec_GL.v:

BinaryToSevenSeg_GL.v:

