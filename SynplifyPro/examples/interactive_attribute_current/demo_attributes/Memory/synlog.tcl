source "/remote/in01home10/nishar/.local/share/data/Synplicity/scm_perforce.tcl"
history clear
project -load /remote/in01home10/nishar/gowin/project/tristate.prj
project -close /remote/in01home10/nishar/gowin/project/tristate.prj
set wid1 [get_window_id]
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_encoding/default_rev/example_proj_syn_encoding_default.srm]
win_activate $wid2
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_encoding/onehot_rev/example_proj_syn_encoding_onehot.srm]
win_activate $wid3
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_encoding/gray_rev/example_proj_syn_encoding_gray.srm]
win_activate $wid4
set wid5 [open_file /remote/in01home10/nishar/reduce/syn_encoding/sequential_rev/example_proj_syn_encoding_sequential.srm]
win_activate $wid5
win_activate $wid2
win_activate $wid3
win_activate $wid4
win_activate $wid5
set wid6 [open_file /remote/in01home10/nishar/reduce/syn_encoding/default_rev/example_proj_syn_encoding_default.srs]
win_activate $wid6
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_hier/default_rev/example_proj_syn_hier_default.srm]
win_close $wid3
win_close $wid6
win_close $wid2
win_close $wid4
win_close $wid5
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_hier/fixed_rev/example_proj_syn_hier_fixed.srm]
win_activate $wid2
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_hier/hard_rev/example_proj_syn_hier_hard.srm]
win_activate $wid3
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_hier/firm_rev/example_proj_syn_hier_firm.srm]
win_activate $wid4
win_activate $wid1
set wid5 [open_file /remote/in01home10/nishar/reduce/syn_hier/soft_rev/example_proj_syn_hier_soft.srm]
win_activate $wid5
win_activate $wid2
win_activate $wid3
win_activate $wid4
set wid6 [open_file /remote/in01home10/nishar/reduce/syn_hier/default_rev/example_proj_syn_hier_default.srs]
win_activate $wid6
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_useenables/default_rev/example_proj_syn_useenables_default.srm]
win_close $wid5
win_close $wid1
win_close $wid2
win_close $wid3
win_close $wid4
win_close $wid6
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_useenables/1_rev/example_proj_syn_useenables_1.srm]
win_activate $wid2
win_activate $wid1
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_useenables/0_rev/example_proj_syn_useenables_0.srm]
win_activate $wid3
win_activate $wid2
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_useenables/default_rev/example_proj_syn_useenables_default.srs]
win_activate $wid4
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_allow_retiming/default_rev/example_proj_syn_allow_retiming_default.srm]
win_close $wid1
win_close $wid2
win_close $wid3
win_close $wid4
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_allow_retiming/1_rev/example_proj_syn_allow_retiming_1.srm]
win_activate $wid2
win_activate $wid1
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_allow_retiming/0_rev/example_proj_syn_allow_retiming_0.srm]
win_activate $wid3
win_activate $wid2
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_allow_retiming/default_rev/example_proj_syn_allow_retiming_default.srs]
win_activate $wid4
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_maxfan/default_rev/example_proj_syn_maxfan_default.srm]
win_close $wid2
win_close $wid4
win_close $wid3
win_close $wid1
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_maxfan/3_rev/example_proj_syn_maxfan_3.srm]
win_activate $wid2
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_maxfan/10000_rev/example_proj_syn_maxfan_10000.srm]
win_activate $wid3
win_activate $wid1
win_activate $wid2
win_activate $wid3
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_maxfan/default_rev/example_proj_syn_maxfan_default.srs]
win_activate $wid4
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_pipeline/default_rev/example_proj_syn_pipeline_default.srm]
win_close $wid1
win_close $wid2
win_close $wid3
win_close $wid4
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_pipeline/1_rev/example_proj_syn_pipeline_1.srm]
win_activate $wid2
win_activate $wid1
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_pipeline/0_rev/example_proj_syn_pipeline_0.srm]
win_activate $wid3
win_activate $wid2
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_pipeline/default_rev/example_proj_syn_pipeline_default.srs]
win_activate $wid4
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_replicate/default_rev/example_proj_syn_replicate_default.srm]
win_close $wid4
win_close $wid2
win_close $wid3
win_close $wid1
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_replicate/0_rev/example_proj_syn_replicate_0.srm]
win_activate $wid2
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_replicate/1_rev/example_proj_syn_replicate_1.srm]
win_activate $wid3
win_activate $wid1
win_activate $wid2
win_activate $wid3
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_replicate/default_rev/example_proj_syn_replicate_default.srs]
win_activate $wid4
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_probe/default_rev/example_proj_syn_probe_default.srm]
win_close $wid2
win_close $wid3
win_close $wid1
win_close $wid4
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_probe/test_pt_rev/example_proj_syn_probe_test_pt.srm]
win_activate $wid2
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_probe/test_pt_bus_rev/example_proj_syn_probe_test_pt_bus.srm]
win_activate $wid3
win_activate $wid1
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_probe/1_rev/example_proj_syn_probe_1.srm]
win_activate $wid4
win_activate $wid2
win_activate $wid3
set wid5 [open_file /remote/in01home10/nishar/reduce/syn_probe/default_rev/example_proj_syn_probe_default.srs]
win_activate $wid5
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_direct_reset/default_rev/example_proj_syn_direct_reset_default.srm]
win_close $wid1
win_close $wid2
win_close $wid3
win_close $wid4
win_close $wid5
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_direct_reset/1_rev/example_proj_syn_direct_reset_1.srm]
win_activate $wid2
win_activate $wid1
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_direct_reset/0_rev/example_proj_syn_direct_reset_0.srm]
win_activate $wid3
win_activate $wid2
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_direct_reset/default_rev/example_proj_syn_direct_reset_default.srs]
win_activate $wid4
set wid1 [open_file /remote/in01home10/nishar/reduce/syn_direct_set/default_rev/example_proj_syn_direct_set_default.srm]
win_activate $wid1
set wid2 [open_file /remote/in01home10/nishar/reduce/syn_direct_set/0_rev/example_proj_syn_direct_set_0.srm]
win_activate $wid2
set wid3 [open_file /remote/in01home10/nishar/reduce/syn_direct_set/1_rev/example_proj_syn_direct_set_1.srm]
win_activate $wid3
win_activate $wid1
win_activate $wid2
win_activate $wid3
set wid4 [open_file /remote/in01home10/nishar/reduce/syn_direct_set/default_rev/example_proj_syn_direct_set_default.srs]
win_activate $wid4
project -close /remote/in01home10/nishar/reduce/syn_encoding/example_proj_syn_encoding.prj
project -close /remote/in01home10/nishar/reduce/syn_hier/example_proj_syn_hier.prj
project -close /remote/in01home10/nishar/reduce/syn_useenables/example_proj_syn_useenables.prj
project -close /remote/in01home10/nishar/reduce/syn_allow_retiming/example_proj_syn_allow_retiming.prj
project -close /remote/in01home10/nishar/reduce/syn_maxfan/example_proj_syn_maxfan.prj
project -close /remote/in01home10/nishar/reduce/syn_pipeline/example_proj_syn_pipeline.prj
project -close /remote/in01home10/nishar/reduce/syn_replicate/example_proj_syn_replicate.prj
project -close /remote/in01home10/nishar/reduce/syn_probe/example_proj_syn_probe.prj
project -close /remote/in01home10/nishar/reduce/syn_direct_reset/example_proj_syn_direct_reset.prj
project -close /remote/in01home10/nishar/reduce/syn_direct_set/example_proj_syn_direct_set.prj
