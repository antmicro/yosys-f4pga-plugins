# The stock equiv_opt pass can apply only a single transformation command
# here we need two: qynth_quicklogic and dsp_ff that follows it. Hence the
# custom function.
proc check_equiv {top} {
    hierarchy -top ${top}

    design -save preopt
    synth_quicklogic -family qlf_k6n10f -top ${top}
    debug dsp_ff -rules ../../qlf_k6n10f-dsp_rules.txt
    design -stash postopt

    design -copy-from preopt  -as gold A:top
    design -copy-from postopt -as gate A:top

    techmap -wb -autoproc -map +/quicklogic/qlf_k6n10f/cells_sim.v
    yosys proc
    opt_expr
    opt_clean

    async2sync
    equiv_make gold gate equiv
    equiv_induct equiv
    equiv_status -assert equiv

    return
}

yosys -import
if { [info procs dsp_ff] == {} } { plugin -i dsp-ff }
plugin -i ql-qlf
yosys -import  ;# ingest plugin commands

read_verilog $::env(DESIGN_TOP).v
design -save read

set TOP "mult_ireg"
design -load read
check_equiv ${TOP}
design -load postopt
yosys cd ${TOP}
stat
select -assert-count 1 t:QL_DSP2
select -assert-count 1 t:*
