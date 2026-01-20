#=========================================================================
# Makefile for ECE 2300
#=========================================================================
# Author : Christopher Batten (Cornell)
# Date   : September 7, 2024

hws = \
  FullAdder_GL.v \
  AdderRippleCarry_4b_GL.v \
  AdderRippleCarry_8b_GL.v \
  Mux2_1b_GL.v \
  Mux2_4b_GL.v \
  Mux2_8b_GL.v \
  BinaryToBinCodedDec_GL.v \
  BinaryToSevenSeg_GL.v \
  Display_GL.v \
  DLatch_GL.v \
  DFF_GL.v \
  DFF_RTL.v \
  DFFR_GL.v \
  DFFR_RTL.v \
  DFFRE_GL.v \
  DFFRE_RTL.v \
  Register_8b_GL.v \
  Register_8b_RTL.v \
  Subtractor_8b_GL.v \
  Counter_8b_GL.v \
  Counter_8b_RTL.v \
  NotePlayerCtrl_GL.v \
  NotePlayerCtrl_RTL.v \
  NotePlayer_GL.v \
  NotePlayer_RTL.v \
  Register_16b_RTL.v \
  Counter_16b_RTL.v \
  Mux2_8b_RTL.v \
  Mux8_1b_RTL.v \
  MultiNotePlayer_RTL.v \
  MusicPlayerCtrl_RTL.v \
  MusicPlayer_RTL.v \
  MusicMem_RTL.v \
  ClockDiv_RTL.v \

tests_partA = \
  FullAdder_GL-test.v \
  AdderRippleCarry_4b_GL-test.v \
  AdderRippleCarry_8b_GL-test.v \
  Mux2_1b_GL-test.v \
  Mux2_4b_GL-test.v \
  Mux2_8b_GL-test.v \
  BinaryToBinCodedDec_GL-test.v \
  BinaryToSevenSeg_GL-test.v \
  Display_GL-test.v \
  DLatch_GL-test.v \
  DFF_GL-test.v \
  DFF_RTL-test.v \
  DFFR_GL-test.v \
  DFFR_RTL-test.v \
  DFFRE_GL-test.v \
  DFFRE_RTL-test.v \
  Register_8b_GL-test.v \
  Register_8b_RTL-test.v \
  Subtractor_8b_GL-test.v \
  Counter_8b_GL-test.v \
  Counter_8b_RTL-test.v \
  NotePlayerCtrl_GL-test.v \
  NotePlayerCtrl_RTL-test.v \
  NotePlayer_GL-test.v \
  NotePlayer_RTL-test.v \

tests_partB = \
  Register_16b_RTL-test.v \
  Counter_16b_RTL-test.v \
  Mux2_8b_RTL-test.v \
  Mux8_1b_RTL-test.v \
  MultiNotePlayer_RTL-test.v \
  MusicPlayer_RTL-test.v \
  ClockDiv_RTL-test.v \

tests = \
  $(tests_partA) \
  $(tests_partB) \

sims = \
   counter-sim.v \
   note-player-sim.v \
   multi-note-player-sim.v \
   music-player-sim.v \

#-------------------------------------------------------------------------
# Basic setup
#-------------------------------------------------------------------------

# Remove all default implicit rules since they can cause subtle bugs
# and they just make things run slower
.SUFFIXES:
% : %,v
% : RCS/%,v
% : RCS/%
% : s.%
% : SCCS/s.%

# Default is to build the prereqs of the all target (defined at bottom)
default : all
.PHONY : default

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------

top_dir     := ..
scripts_dir := $(top_dir)/scripts
hw_dir      := $(top_dir)/hw
test_dir    := $(top_dir)/test
sim_dir     := $(top_dir)/sim

VPATH := $(hw_dir) $(test_dir) $(sim_dir)

#-------------------------------------------------------------------------
# Programs
#-------------------------------------------------------------------------

VMKDEPS          := $(scripts_dir)/mk-verilog-deps
WARN2ERR         := $(scripts_dir)/warnings2errors

VERILATOR_FLAGS  := --quiet --timing -Wall -Wno-DECLFILENAME
VERILATOR_LINT   := verilator --lint-only $(VERILATOR_FLAGS)

IVERILOG_FLAGS   := -Wall -Winfloop -Wno-timescale -g2012
IVERILOG_COMPILE := $(WARN2ERR) iverilog $(IVERILOG_FLAGS)

#-------------------------------------------------------------------------
# Tests
#-------------------------------------------------------------------------

test_deps       := $(patsubst %.v, %.d,   $(tests))
test_exes       := $(patsubst %.v, %,     $(tests))
test_logs_partA := $(patsubst %.v, %.log, $(tests_partA))
test_logs_partB := $(patsubst %.v, %.log, $(tests_partB))
test_logs       := $(patsubst %.v, %.log, $(tests))

$(test_deps) : %.d : %.v
	$(VMKDEPS) -I $(hw_dir) -I $(test_dir) $* $<

$(test_exes) : % : %.v
	$(VERILATOR_LINT) -I$(hw_dir) -I$(test_dir) --top-module Top $<
	$(IVERILOG_COMPILE) -I $(hw_dir) -I $(test_dir) -s Top -o $@ $<

$(test_logs) : %.log : %
	./$< > $@

check-partA : $(test_logs_partA)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs_partA) | tee test-summary-partA.txt
	@echo ""

check-partB : $(test_logs_partB)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs_partB) | tee test-summary-partB.txt
	@echo ""

check : $(test_logs)
	@sed -e '/^$$/N;/\n.*finish/d' $(test_logs) | tee test-summary.txt
	@echo ""

deps += $(test_deps)
exes += $(test_exes)
logs += $(test_logs)
junk += $(test_deps) $(test_exes) $(test_logs)
junk += test-summary-partA.txt test-summary-partB.txt test-summary.txt

#-------------------------------------------------------------------------
# Sims
#-------------------------------------------------------------------------

sim_deps := $(patsubst %.v, %.d, $(sims))
sim_exes := $(patsubst %.v, %,   $(sims))

$(sim_deps) : %.d : %.v
	$(VMKDEPS) -I $(hw_dir) -I $(sim_dir) $* $<

$(sim_exes) : % : %.v
	$(VERILATOR_LINT) -I$(hw_dir) -I$(sim_dir) --top-module Top $<
	$(IVERILOG_COMPILE) -I $(hw_dir) -I $(sim_dir) -s Top -o $@ $<

deps += $(sim_deps)
exes += $(sim_exes)
junk += $(sim_deps) $(sim_exes)

#-------------------------------------------------------------------------
# Autodependency files
#-------------------------------------------------------------------------

-include $(deps)

deps : $(deps)
.PHONY : deps

#-------------------------------------------------------------------------
# configure information
#-------------------------------------------------------------------------

configure_prereq = $(top_dir)/configure.ac

$(top_dir)/configure : $(configure_prereq)
	cd $(top_dir) && autoconf

config.status : $(top_dir)/configure
	./config.status --recheck

Makefile : $(top_dir)/Makefile.in config.status
	./config.status

dist_junk += config.status Makefile config.log

#-------------------------------------------------------------------------
# Default
#-------------------------------------------------------------------------

all : $(sim_exes)

.PHONY : all

#-------------------------------------------------------------------------
# Makefile debugging
#-------------------------------------------------------------------------
# This handy rule will display the contents of any make variable by
# using the target debug-<varname>. So for example, make debug-junk will
# display the contents of the junk variable.

debug-% :
	@echo $* = $($*)

#-------------------------------------------------------------------------
# Clean up junk
#-------------------------------------------------------------------------

clean :
	rm -rf *~ \#* *.vcd $(junk)

distclean :
	rm -rf *~ \#* *.vcd $(junk) $(dist_junk)

.PHONY : clean distclean

