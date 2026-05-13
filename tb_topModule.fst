$date
	Tue May 12 21:03:18 2026
$end
$version
	Icarus Verilog
$end
$timescale
	1ps
$end
$scope module tb_topModule $end
$var wire 1 ! out_valid $end
$var wire 1 " in_ready $end
$var parameter 3 # COMPUTE $end
$var reg 1 $ CLK $end
$var reg 8 % activation_in [7:0] $end
$var reg 1 & activation_valid $end
$var reg 1 ' out_ready $end
$var reg 1 ( rst $end
$var reg 8 ) weight_in [7:0] $end
$var reg 1 * weight_valid $end
$var integer 32 + fail_count [31:0] $end
$var integer 32 , pass_count [31:0] $end
$var integer 32 - timeout [31:0] $end
$scope module u_top $end
$var wire 8 . activation_in [7:0] $end
$var wire 1 & activation_valid $end
$var wire 1 $ clk $end
$var wire 1 / load_done $end
$var wire 1 ' out_ready $end
$var wire 1 ( rst $end
$var wire 8 0 weight_in [7:0] $end
$var wire 1 * weight_valid $end
$var wire 1 1 weight_read_en $end
$var wire 1 2 start_compute $end
$var wire 1 ! out_valid $end
$var wire 8 3 mux_res [7:0] $end
$var wire 1 4 load_weight $end
$var wire 1 5 load_input $end
$var wire 1 6 load_doneB $end
$var wire 1 7 load_doneA $end
$var wire 1 8 loadSel $end
$var wire 1 9 input_read_en $end
$var wire 1 : input_load_done $end
$var wire 1 " in_ready $end
$var wire 1 ; done_compute $end
$var wire 1 < bufSel $end
$var wire 1 = act_valid_mux $end
$var reg 1 > fb_active $end
$var reg 2 ? fb_idx [1:0] $end
$var reg 1 @ feedback_valid $end
$var reg 1 A use_feedback $end
$scope begin genblk1[0] $end
$var parameter 2 B r $end
$scope begin genblk1[0] $end
$var parameter 2 C c $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 D c $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 E c $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 F c $end
$upscope $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 G r $end
$scope begin genblk1[0] $end
$var parameter 2 H c $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 I c $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 J c $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 K c $end
$upscope $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 L r $end
$scope begin genblk1[0] $end
$var parameter 2 M c $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 N c $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 O c $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 P c $end
$upscope $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 Q r $end
$scope begin genblk1[0] $end
$var parameter 2 R c $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 S c $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 T c $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 U c $end
$upscope $end
$upscope $end
$scope module u_array $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 1 2 start_compute $end
$var parameter 32 V TOTAL_CYCLES $end
$var reg 1 W computing $end
$var reg 3 X cycle_count [2:0] $end
$var reg 1 ; done $end
$scope begin genblk1[0] $end
$var parameter 2 Y i $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 Z i $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 [ i $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 \ i $end
$upscope $end
$scope begin genblk2[0] $end
$var parameter 2 ] r $end
$scope begin genblk1[0] $end
$var parameter 2 ^ c $end
$scope module u_pe $end
$var wire 8 _ a_in [7:0] $end
$var wire 32 ` acc_in [31:0] $end
$var wire 8 a b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 b acc_res [31:0] $end
$var reg 8 c a_out [7:0] $end
$var reg 32 d acc_out [31:0] $end
$var reg 8 e b_out [7:0] $end
$var reg 8 f w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 g a_in [7:0] $end
$var wire 32 h acc_in [31:0] $end
$var wire 8 i b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 j acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 k c $end
$scope module u_pe $end
$var wire 8 l a_in [7:0] $end
$var wire 32 m acc_in [31:0] $end
$var wire 8 n b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 o acc_res [31:0] $end
$var reg 8 p a_out [7:0] $end
$var reg 32 q acc_out [31:0] $end
$var reg 8 r b_out [7:0] $end
$var reg 8 s w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 t a_in [7:0] $end
$var wire 32 u acc_in [31:0] $end
$var wire 8 v b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 w acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 x c $end
$scope module u_pe $end
$var wire 8 y a_in [7:0] $end
$var wire 32 z acc_in [31:0] $end
$var wire 8 { b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 | acc_res [31:0] $end
$var reg 8 } a_out [7:0] $end
$var reg 32 ~ acc_out [31:0] $end
$var reg 8 !" b_out [7:0] $end
$var reg 8 "" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 #" a_in [7:0] $end
$var wire 32 $" acc_in [31:0] $end
$var wire 8 %" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 &" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 '" c $end
$scope module u_pe $end
$var wire 8 (" a_in [7:0] $end
$var wire 32 )" acc_in [31:0] $end
$var wire 8 *" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 +" acc_res [31:0] $end
$var reg 8 ," a_out [7:0] $end
$var reg 32 -" acc_out [31:0] $end
$var reg 8 ." b_out [7:0] $end
$var reg 8 /" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 0" a_in [7:0] $end
$var wire 32 1" acc_in [31:0] $end
$var wire 8 2" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 3" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk2[1] $end
$var parameter 2 4" r $end
$scope begin genblk1[0] $end
$var parameter 2 5" c $end
$scope module u_pe $end
$var wire 8 6" a_in [7:0] $end
$var wire 32 7" acc_in [31:0] $end
$var wire 8 8" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 9" acc_res [31:0] $end
$var reg 8 :" a_out [7:0] $end
$var reg 32 ;" acc_out [31:0] $end
$var reg 8 <" b_out [7:0] $end
$var reg 8 =" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 >" a_in [7:0] $end
$var wire 32 ?" acc_in [31:0] $end
$var wire 8 @" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 A" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 B" c $end
$scope module u_pe $end
$var wire 8 C" a_in [7:0] $end
$var wire 32 D" acc_in [31:0] $end
$var wire 8 E" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 F" acc_res [31:0] $end
$var reg 8 G" a_out [7:0] $end
$var reg 32 H" acc_out [31:0] $end
$var reg 8 I" b_out [7:0] $end
$var reg 8 J" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 K" a_in [7:0] $end
$var wire 32 L" acc_in [31:0] $end
$var wire 8 M" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 N" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 O" c $end
$scope module u_pe $end
$var wire 8 P" a_in [7:0] $end
$var wire 32 Q" acc_in [31:0] $end
$var wire 8 R" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 S" acc_res [31:0] $end
$var reg 8 T" a_out [7:0] $end
$var reg 32 U" acc_out [31:0] $end
$var reg 8 V" b_out [7:0] $end
$var reg 8 W" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 X" a_in [7:0] $end
$var wire 32 Y" acc_in [31:0] $end
$var wire 8 Z" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 [" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 \" c $end
$scope module u_pe $end
$var wire 8 ]" a_in [7:0] $end
$var wire 32 ^" acc_in [31:0] $end
$var wire 8 _" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 `" acc_res [31:0] $end
$var reg 8 a" a_out [7:0] $end
$var reg 32 b" acc_out [31:0] $end
$var reg 8 c" b_out [7:0] $end
$var reg 8 d" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 e" a_in [7:0] $end
$var wire 32 f" acc_in [31:0] $end
$var wire 8 g" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 h" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk2[2] $end
$var parameter 3 i" r $end
$scope begin genblk1[0] $end
$var parameter 2 j" c $end
$scope module u_pe $end
$var wire 8 k" a_in [7:0] $end
$var wire 32 l" acc_in [31:0] $end
$var wire 8 m" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 n" acc_res [31:0] $end
$var reg 8 o" a_out [7:0] $end
$var reg 32 p" acc_out [31:0] $end
$var reg 8 q" b_out [7:0] $end
$var reg 8 r" w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 s" a_in [7:0] $end
$var wire 32 t" acc_in [31:0] $end
$var wire 8 u" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 v" acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 w" c $end
$scope module u_pe $end
$var wire 8 x" a_in [7:0] $end
$var wire 32 y" acc_in [31:0] $end
$var wire 8 z" b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 {" acc_res [31:0] $end
$var reg 8 |" a_out [7:0] $end
$var reg 32 }" acc_out [31:0] $end
$var reg 8 ~" b_out [7:0] $end
$var reg 8 !# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 "# a_in [7:0] $end
$var wire 32 ## acc_in [31:0] $end
$var wire 8 $# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 %# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 &# c $end
$scope module u_pe $end
$var wire 8 '# a_in [7:0] $end
$var wire 32 (# acc_in [31:0] $end
$var wire 8 )# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 *# acc_res [31:0] $end
$var reg 8 +# a_out [7:0] $end
$var reg 32 ,# acc_out [31:0] $end
$var reg 8 -# b_out [7:0] $end
$var reg 8 .# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 /# a_in [7:0] $end
$var wire 32 0# acc_in [31:0] $end
$var wire 8 1# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 2# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 3# c $end
$scope module u_pe $end
$var wire 8 4# a_in [7:0] $end
$var wire 32 5# acc_in [31:0] $end
$var wire 8 6# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 7# acc_res [31:0] $end
$var reg 8 8# a_out [7:0] $end
$var reg 32 9# acc_out [31:0] $end
$var reg 8 :# b_out [7:0] $end
$var reg 8 ;# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 <# a_in [7:0] $end
$var wire 32 =# acc_in [31:0] $end
$var wire 8 ># b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 ?# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk2[3] $end
$var parameter 3 @# r $end
$scope begin genblk1[0] $end
$var parameter 2 A# c $end
$scope module u_pe $end
$var wire 8 B# a_in [7:0] $end
$var wire 32 C# acc_in [31:0] $end
$var wire 8 D# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 E# acc_res [31:0] $end
$var reg 8 F# a_out [7:0] $end
$var reg 32 G# acc_out [31:0] $end
$var reg 8 H# b_out [7:0] $end
$var reg 8 I# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 J# a_in [7:0] $end
$var wire 32 K# acc_in [31:0] $end
$var wire 8 L# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 M# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[1] $end
$var parameter 2 N# c $end
$scope module u_pe $end
$var wire 8 O# a_in [7:0] $end
$var wire 32 P# acc_in [31:0] $end
$var wire 8 Q# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 R# acc_res [31:0] $end
$var reg 8 S# a_out [7:0] $end
$var reg 32 T# acc_out [31:0] $end
$var reg 8 U# b_out [7:0] $end
$var reg 8 V# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 W# a_in [7:0] $end
$var wire 32 X# acc_in [31:0] $end
$var wire 8 Y# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 Z# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[2] $end
$var parameter 3 [# c $end
$scope module u_pe $end
$var wire 8 \# a_in [7:0] $end
$var wire 32 ]# acc_in [31:0] $end
$var wire 8 ^# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 _# acc_res [31:0] $end
$var reg 8 `# a_out [7:0] $end
$var reg 32 a# acc_out [31:0] $end
$var reg 8 b# b_out [7:0] $end
$var reg 8 c# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 d# a_in [7:0] $end
$var wire 32 e# acc_in [31:0] $end
$var wire 8 f# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 g# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk1[3] $end
$var parameter 3 h# c $end
$scope module u_pe $end
$var wire 8 i# a_in [7:0] $end
$var wire 32 j# acc_in [31:0] $end
$var wire 8 k# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var wire 1 4 w_load $end
$var wire 32 l# acc_res [31:0] $end
$var reg 8 m# a_out [7:0] $end
$var reg 32 n# acc_out [31:0] $end
$var reg 8 o# b_out [7:0] $end
$var reg 8 p# w_reg [7:0] $end
$scope module u_mac $end
$var wire 8 q# a_in [7:0] $end
$var wire 32 r# acc_in [31:0] $end
$var wire 8 s# b_in [7:0] $end
$var wire 1 $ clk $end
$var wire 1 ( rst $end
$var reg 32 t# acc_out [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$upscope $end
$scope begin genblk3[0] $end
$var parameter 2 u# i $end
$upscope $end
$scope begin genblk3[1] $end
$var parameter 2 v# i $end
$upscope $end
$scope begin genblk3[2] $end
$var parameter 3 w# i $end
$upscope $end
$scope begin genblk3[3] $end
$var parameter 3 x# i $end
$upscope $end
$upscope $end
$scope module u_ctrl $end
$var wire 1 $ clk $end
$var wire 1 ; done $end
$var wire 1 / load_done $end
$var wire 1 ( rst $end
$var wire 1 : input_load_done $end
$var parameter 3 y# COMPUTE $end
$var parameter 3 z# INIT $end
$var parameter 3 {# LOAD_I $end
$var parameter 3 |# LOAD_W $end
$var parameter 3 }# NEXT_TILE $end
$var parameter 32 ~# NUM_LAYERS $end
$var parameter 3 !$ WAIT_DONE $end
$var parameter 3 "$ WRITEBACK $end
$var reg 1 #$ bg_load_done $end
$var reg 1 < bufSel $end
$var reg 2 $$ counter [1:0] $end
$var reg 1 9 input_read_en $end
$var reg 1 8 loadSel $end
$var reg 1 5 load_input $end
$var reg 1 4 load_weight $end
$var reg 3 %$ next_state [2:0] $end
$var reg 1 2 start_compute $end
$var reg 3 &$ state [2:0] $end
$var reg 1 1 weight_read_en $end
$upscope $end
$scope module u_input $end
$var wire 1 $ clk $end
$var wire 8 '$ in_data [7:0] $end
$var wire 1 = in_valid $end
$var wire 1 5 load $end
$var wire 1 9 read_en $end
$var wire 1 ( rst $end
$var wire 1 " in_ready $end
$var reg 1 ($ full $end
$var reg 1 : input_load_done $end
$var reg 3 )$ wr_ptr [2:0] $end
$scope begin $ivl_for_loop0 $end
$var integer 32 *$ i [31:0] $end
$upscope $end
$upscope $end
$scope module u_output $end
$var wire 1 $ clk $end
$var wire 1 ; done $end
$var wire 1 ' out_ready $end
$var wire 1 ( rst $end
$var wire 1 ! valid $end
$var reg 32 +$ biased [31:0] $end
$var reg 1 ,$ out_valid_r $end
$scope begin $ivl_for_loop1 $end
$var integer 32 -$ i [31:0] $end
$upscope $end
$upscope $end
$scope module u_weight $end
$var wire 1 $ clk $end
$var wire 8 .$ in_data [7:0] $end
$var wire 1 * in_valid $end
$var wire 1 /$ load $end
$var wire 1 0$ read_en $end
$var wire 1 ( rst $end
$var reg 1 7 load_done $end
$var reg 5 1$ wr_ptr [4:0] $end
$scope begin $ivl_for_loop2 $end
$var integer 32 2$ r [31:0] $end
$scope begin $ivl_for_loop3 $end
$var integer 32 3$ c [31:0] $end
$upscope $end
$upscope $end
$scope begin $ivl_for_loop4 $end
$var integer 32 4$ r [31:0] $end
$scope begin $ivl_for_loop5 $end
$var integer 32 5$ c [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$scope module u_weight2 $end
$var wire 1 $ clk $end
$var wire 8 6$ in_data [7:0] $end
$var wire 1 * in_valid $end
$var wire 1 7$ load $end
$var wire 1 8$ read_en $end
$var wire 1 ( rst $end
$var reg 1 6 load_done $end
$var reg 5 9$ wr_ptr [4:0] $end
$scope begin $ivl_for_loop2 $end
$var integer 32 :$ r [31:0] $end
$scope begin $ivl_for_loop3 $end
$var integer 32 ;$ c [31:0] $end
$upscope $end
$upscope $end
$scope begin $ivl_for_loop4 $end
$var integer 32 <$ r [31:0] $end
$scope begin $ivl_for_loop5 $end
$var integer 32 =$ c [31:0] $end
$upscope $end
$upscope $end
$upscope $end
$upscope $end
$scope task do_reset $end
$upscope $end
$scope task load_layer $end
$var integer 32 >$ k [31:0] $end
$var integer 32 ?$ layer [31:0] $end
$upscope $end
$scope task send_inputs $end
$var integer 32 @$ j [31:0] $end
$upscope $end
$scope task send_weights $end
$var reg 64 A$ layer_num [63:0] $end
$var integer 32 B$ j [31:0] $end
$upscope $end
$scope task wait_and_check $end
$var reg 32 C$ e0 [31:0] $end
$var reg 32 D$ e1 [31:0] $end
$var reg 32 E$ e2 [31:0] $end
$var reg 32 F$ e3 [31:0] $end
$var reg 128 G$ label [127:0] $end
$upscope $end
$upscope $end
$enddefinitions $end
$comment Show the parameter values. $end
$dumpall
b101 "$
b100 !$
b11 ~#
b110 }#
b1 |#
b10 {#
b0 z#
b11 y#
b11 x#
b10 w#
b1 v#
b0 u#
b11 h#
b10 [#
b1 N#
b0 A#
b11 @#
b11 3#
b10 &#
b1 w"
b0 j"
b10 i"
b11 \"
b10 O"
b1 B"
b0 5"
b1 4"
b11 '"
b10 x
b1 k
b0 ^
b0 ]
b11 \
b10 [
b1 Z
b0 Y
b111 V
b11 U
b10 T
b1 S
b0 R
b11 Q
b11 P
b10 O
b1 N
b0 M
b10 L
b11 K
b10 J
b1 I
b0 H
b1 G
b11 F
b10 E
b1 D
b0 C
b0 B
b11 #
$end
#0
$dumpvars
bx G$
bx F$
bx E$
bx D$
bx C$
bx B$
bx A$
bx @$
bx ?$
bx >$
b0 =$
b0 <$
b100 ;$
b100 :$
bx 9$
08$
07$
b0 6$
b0 5$
b0 4$
b100 3$
b100 2$
bx 1$
00$
0/$
b0 .$
b0 -$
x,$
bx +$
b0 *$
bx )$
x($
bx '$
bx &$
b0 %$
bx $$
x#$
b0 t#
b0 s#
b0 r#
b0 q#
b0 p#
b0 o#
b0 n#
b0 m#
b0 l#
b0 k#
b0 j#
b0 i#
b0 g#
b0 f#
b0 e#
b0 d#
b0 c#
b0 b#
b0 a#
b0 `#
b0 _#
b0 ^#
b0 ]#
b0 \#
b0 Z#
b0 Y#
b0 X#
b0 W#
b0 V#
b0 U#
b0 T#
b0 S#
b0 R#
b0 Q#
b0 P#
b0 O#
b0 M#
b0 L#
b0 K#
bx J#
b0 I#
b0 H#
b0 G#
b0 F#
b0 E#
b0 D#
b0 C#
bx B#
b0 ?#
b0 >#
b0 =#
b0 <#
b0 ;#
b0 :#
b0 9#
b0 8#
b0 7#
b0 6#
b0 5#
b0 4#
b0 2#
b0 1#
b0 0#
b0 /#
b0 .#
b0 -#
b0 ,#
b0 +#
b0 *#
b0 )#
b0 (#
b0 '#
b0 %#
b0 $#
b0 ##
b0 "#
b0 !#
b0 ~"
b0 }"
b0 |"
b0 {"
b0 z"
b0 y"
b0 x"
b0 v"
b0 u"
b0 t"
bx s"
b0 r"
b0 q"
b0 p"
b0 o"
b0 n"
b0 m"
b0 l"
bx k"
b0 h"
b0 g"
b0 f"
b0 e"
b0 d"
b0 c"
b0 b"
b0 a"
b0 `"
b0 _"
b0 ^"
b0 ]"
b0 ["
b0 Z"
b0 Y"
b0 X"
b0 W"
b0 V"
b0 U"
b0 T"
b0 S"
b0 R"
b0 Q"
b0 P"
b0 N"
b0 M"
b0 L"
b0 K"
b0 J"
b0 I"
b0 H"
b0 G"
b0 F"
b0 E"
b0 D"
b0 C"
b0 A"
b0 @"
b0 ?"
bx >"
b0 ="
b0 <"
b0 ;"
b0 :"
b0 9"
b0 8"
b0 7"
bx 6"
b0 3"
b0 2"
b0 1"
b0 0"
b0 /"
b0 ."
b0 -"
b0 ,"
b0 +"
b0 *"
b0 )"
b0 ("
b0 &"
b0 %"
b0 $"
b0 #"
b0 ""
b0 !"
b0 ~
b0 }
b0 |
b0 {
b0 z
b0 y
b0 w
b0 v
b0 u
b0 t
b0 s
b0 r
b0 q
b0 p
b0 o
b0 n
b0 m
b0 l
b0 j
b0 i
b0 h
bx g
b0 f
b0 e
b0 d
b0 c
b0 b
b0 a
b0 `
bx _
b0 X
0W
xA
x@
bx ?
x>
x=
x<
0;
x:
09
x8
x7
x6
05
04
bx 3
02
01
b0 0
x/
b0 .
bx -
b0 ,
b0 +
0*
b0 )
1(
0'
0&
b0 %
0$
x"
x!
$end
#5000
0/
b1 %$
b0 3
b0 '$
0=
b0 B#
b0 J#
b0 k"
b0 s"
b0 6"
b0 >"
b0 _
b0 g
1"
0($
0:
b0 )$
07
b0 1$
06
b0 9$
0!
0,$
08
0#$
b0 $$
0<
b0 &$
b0 ?
0>
0@
0A
b100 *$
1$
#10000
0$
#15000
b100 *$
1$
#20000
0$
#25000
b100 *$
1$
#30000
0$
#35000
b100 *$
1$
#40000
0$
#45000
1/$
14
b1 &$
b100 *$
0(
1$
#50000
0$
#55000
b0 B$
b0 A$
b10000 >$
b0 ?$
1$
#60000
0$
#65000
1$
#66000
b1 B$
b1 )
b1 0
b1 .$
b1 6$
1*
#70000
0$
#75000
b1 1$
1$
#76000
b10 B$
b10 )
b10 0
b10 .$
b10 6$
#80000
0$
#85000
b10 1$
1$
#86000
b11 B$
b11 )
b11 0
b11 .$
b11 6$
#90000
0$
#95000
b11 1$
1$
#96000
b100 B$
b100 )
b100 0
b100 .$
b100 6$
#100000
0$
#105000
b100 1$
1$
#106000
b101 B$
b101 )
b101 0
b101 .$
b101 6$
#110000
0$
#115000
b101 1$
1$
#116000
b110 B$
b110 )
b110 0
b110 .$
b110 6$
#120000
0$
#125000
b110 1$
1$
#126000
b111 B$
b111 )
b111 0
b111 .$
b111 6$
#130000
0$
#135000
b111 1$
1$
#136000
b1000 B$
b1000 )
b1000 0
b1000 .$
b1000 6$
#140000
0$
#145000
b1000 1$
1$
#146000
b1001 B$
b1 )
b1 0
b1 .$
b1 6$
#150000
0$
#155000
b1001 1$
1$
#156000
b1010 B$
b10 )
b10 0
b10 .$
b10 6$
#160000
0$
#165000
b1010 1$
1$
#166000
b1011 B$
b11 )
b11 0
b11 .$
b11 6$
#170000
0$
#175000
b1011 1$
1$
#176000
b1100 B$
b100 )
b100 0
b100 .$
b100 6$
#180000
0$
#185000
b1100 1$
1$
#186000
b1101 B$
b101 )
b101 0
b101 .$
b101 6$
#190000
0$
#195000
b1101 1$
1$
#196000
b1110 B$
b110 )
b110 0
b110 .$
b110 6$
#200000
0$
#205000
b1110 1$
1$
#206000
b1111 B$
b111 )
b111 0
b111 .$
b111 6$
#210000
0$
#215000
b1111 1$
1$
#216000
b10000 B$
b1000 )
b1000 0
b1000 .$
b1000 6$
#220000
0$
#225000
b10 %$
14
1/
17
b0 1$
1$
#226000
b0 @$
b0 )
b0 0
b0 .$
b0 6$
0*
#230000
0$
#235000
b1000 k#
b1000 s#
b111 ^#
b111 f#
b110 Q#
b110 Y#
b101 D#
b101 L#
b100 6#
b100 >#
b11 )#
b11 1#
b10 z"
b10 $#
b1 m"
b1 u"
b1000 _"
b1000 g"
b111 R"
b111 Z"
b110 E"
b110 M"
b101 8"
b101 @"
b100 *"
b100 2"
b11 {
b11 %"
b10 n
b10 v
b1 a
b1 i
b100 4$
b100 5$
10$
0/$
11
15
04
0/
18
b10 &$
07
1$
#236000
b1 3
b1 '$
1=
b1 @$
b1 %
b1 .
1&
#240000
0$
#245000
b1 )$
1$
#246000
b10 @$
#250000
0$
#255000
b10 )$
1$
#256000
b11 @$
#260000
0$
#265000
b11 )$
1$
#266000
b100 @$
#270000
0$
#275000
b11 %$
11
15
0"
1($
1:
b0 )$
1$
#276000
b0 3
b0 '$
0=
b0 %
b0 .
0&
#280000
0$
#285000
17$
14
19
12
11
05
0:
b11 &$
1$
#290000
0$
#295000
b101 E#
b101 M#
b1 n"
b1 v"
b101 9"
b101 A"
b1 b
b1 j
1W
1"
0($
b1 B#
b1 J#
b1 k"
b1 s"
b1 6"
b1 >"
b1 _
b1 g
1$
#296000
b0 B$
b1 A$
b10000 >$
b1 ?$
#300000
0$
#305000
b110 R#
b110 Z#
b110 E#
b110 M#
b10 {"
b10 %#
b110 n"
b110 v"
b110 F"
b110 N"
b110 9"
b110 A"
b10 o
b10 w
b1 X
b101 G#
b1 F#
b1 O#
b1 W#
b1 p"
b1 C#
b1 K#
b1 o"
b1 x"
b1 "#
b101 ;"
b101 l"
b101 t"
b1 :"
b1 C"
b1 K"
b1 d
b1 7"
b1 ?"
b1 c
b1 l
b1 t
1$
#306000
b1 B$
b1 )
b1 0
b1 .$
b1 6$
1*
#310000
0$
#315000
b1000 F"
b1000 N"
b11 |
b11 &"
b111 n"
b111 v"
b1000 {"
b1000 %#
b111 S"
b111 ["
b1011 E#
b1011 M#
b1000 R#
b1000 Z#
b11 *#
b11 2#
b111 _#
b111 g#
b10 q
b10 D"
b10 L"
b1 p
b1 y
b1 #"
b110 ;"
b110 l"
b110 t"
b110 H"
b110 y"
b110 ##
b1 G"
b1 P"
b1 X"
b110 p"
b110 C#
b110 K#
b10 }"
b10 P#
b10 X#
b1 |"
b1 '#
b1 /#
b110 G#
b110 T#
b1 S#
b1 \#
b1 d#
b10 X
b1 9$
1$
#316000
b10 B$
b0 )
b0 0
b0 .$
b0 6$
#320000
0$
#325000
b1000 l#
b1000 t#
b1010 _#
b1010 g#
b100 7#
b100 ?#
b1110 R#
b1110 Z#
b1100 E#
b1100 M#
b1010 *#
b1010 2#
b1000 `"
b1000 h"
b1010 {"
b1010 %#
b1010 S"
b1010 ["
b100 +"
b100 3"
b11 X
b111 a#
b1 `#
b1 i#
b1 q#
b1000 T#
b1011 G#
b11 ,#
b11 ]#
b11 e#
b1 +#
b1 4#
b1 <#
b1000 }"
b1000 P#
b1000 X#
b111 p"
b111 C#
b111 K#
b111 U"
b111 (#
b111 0#
b1 T"
b1 ]"
b1 e"
b1000 H"
b1000 y"
b1000 ##
b11 ~
b11 Q"
b11 Y"
b1 }
b1 ("
b1 0"
b10 9$
1$
#326000
b11 B$
#330000
0$
#335000
b1100 `"
b1100 h"
b1101 *#
b1101 2#
b1100 7#
b1100 ?#
b10000 R#
b10000 Z#
b10001 _#
b10001 g#
b1100 l#
b1100 t#
b100 -"
b100 ^"
b100 f"
b1 ,"
b1010 U"
b1010 (#
b1010 0#
b1000 b"
b1000 5#
b1000 =#
b1 a"
b1010 }"
b1010 P#
b1010 X#
b1010 ,#
b1010 ]#
b1010 e#
b100 9#
b100 j#
b100 r#
b1 8#
b1100 G#
b1110 T#
b1010 a#
b1000 n#
b1 m#
b100 X
b11 9$
1$
#336000
b100 B$
#340000
0$
#345000
b10100 l#
b10100 t#
b10100 _#
b10100 g#
b10000 7#
b10000 ?#
b101 X
b1100 n#
b10001 a#
b10000 T#
b1100 9#
b1100 j#
b1100 r#
b1101 ,#
b1101 ]#
b1101 e#
b1100 b"
b1100 5#
b1100 =#
b100 9$
1$
#346000
b101 B$
#350000
0$
#355000
b11000 l#
b11000 t#
b10000 9#
b10000 j#
b10000 r#
b10100 a#
b10100 n#
b110 X
b101 9$
1$
#356000
b110 B$
b1 )
b1 0
b1 .$
b1 6$
#360000
0$
#365000
b100 %$
11
19
12
14
1;
0W
b11000 n#
b110 9$
1$
#366000
b111 B$
b0 )
b0 0
b0 .$
b0 6$
#370000
0$
#375000
11
09
02
14
0;
b0 X
1W
b100 &$
1!
1,$
b111 9$
b100 -$
b11000 +$
1$
#376000
b1000 B$
#380000
0$
#385000
b1100 3
b1100 '$
b1 X
b1000 9$
1A
1$
#386000
b1001 B$
#390000
0$
#395000
b10 X
b1001 9$
1$
#396000
b1010 B$
#400000
0$
#405000
b11 X
b1010 9$
1$
#406000
b1011 B$
b1 )
b1 0
b1 .$
b1 6$
#410000
0$
#415000
b100 X
b1011 9$
1$
#416000
b1100 B$
b0 )
b0 0
b0 .$
b0 6$
#420000
0$
#425000
b101 X
b1100 9$
1$
#426000
b1101 B$
#430000
0$
#435000
b110 X
b1101 9$
1$
#436000
b1110 B$
#440000
0$
#445000
11
14
1;
0W
b1110 9$
1$
#446000
b1111 B$
#450000
0$
#455000
11
14
0;
b1111 9$
b11000 +$
b100 -$
1$
#456000
b10000 B$
b1 )
b1 0
b1 .$
b1 6$
#460000
0$
#465000
11
14
1/
16
b0 9$
1$
#466000
b1 ,
b0 -
b101010000110001001011010100110000110000 G$
b11000 F$
b10100 E$
b10000 D$
b1100 C$
b0 )
b0 0
b0 .$
b0 6$
0*
#470000
0$
#475000
b101 %$
11
14
0/
1#$
06
1$
#476000
1'
#480000
0$
#485000
00$
07$
b110 %$
01
04
b101 &$
0!
0,$
1$
#486000
b0 @$
0'
#490000
0$
#495000
b10 %$
b110 &$
1$
#496000
b1 @$
b1 %
b1 .
1&
#500000
0$
#505000
b10001 l#
b10001 t#
b1101 _#
b1101 g#
b1010 R#
b1010 Z#
b111 E#
b111 M#
b1100 7#
b1100 ?#
b1011 *#
b1011 2#
b1000 {"
b1000 %#
b110 n"
b110 v"
b100 `"
b100 h"
b11 S"
b11 ["
b11 F"
b11 N"
b1 9"
b1 A"
b0 +"
b0 3"
b0 |
b0 &"
b0 o
b0 w
b1 b
b1 j
b100 <$
b100 =$
b1 k#
b1 s#
b0 ^#
b0 f#
b0 Q#
b0 Y#
b0 D#
b0 L#
b0 6#
b0 >#
b1 )#
b1 1#
b0 z"
b0 $#
b0 m"
b0 u"
b0 _"
b0 g"
b0 R"
b0 Z"
b1 E"
b1 M"
b0 8"
b0 @"
b0 *"
b0 2"
b0 {
b0 %"
b0 n
b0 v
b1 a
b1 i
18$
11
15
08
b1 $$
1<
0#$
b10 &$
1$
#506000
b10 @$
#510000
0$
#515000
b1 F"
b1 N"
b0 S"
b0 ["
b0 `"
b0 h"
b1 n"
b1 v"
b11 {"
b11 %#
b100 *#
b100 2#
b100 7#
b100 ?#
b110 E#
b110 M#
b1000 R#
b1000 Z#
b1011 _#
b1011 g#
b1101 l#
b1101 t#
1=
b0 q
b0 D"
b0 L"
b0 ~
b0 Q"
b0 Y"
b0 -"
b0 ^"
b0 f"
b1 ;"
b1 l"
b1 t"
b11 H"
b11 y"
b11 ##
b11 U"
b11 (#
b11 0#
b100 b"
b100 5#
b100 =#
b110 p"
b110 C#
b110 K#
b1000 }"
b1000 P#
b1000 X#
b1011 ,#
b1011 ]#
b1011 e#
b1100 9#
b1100 j#
b1100 r#
b111 G#
b1010 T#
b1101 a#
b10001 n#
1>
1@
1$
#516000
b11 @$
#520000
0$
#525000
b101 l#
b101 t#
b100 _#
b100 g#
b11 R#
b11 Z#
b1 E#
b1 M#
b0 7#
b0 ?#
b1 *#
b1 2#
b1 {"
b1 %#
b10000 3
b10000 '$
b1101 n#
b1011 a#
b1000 T#
b110 G#
b100 9#
b100 j#
b100 r#
b100 ,#
b100 ]#
b100 e#
b11 }"
b11 P#
b11 X#
b1 p"
b1 C#
b1 K#
b0 b"
b0 5#
b0 =#
b0 U"
b0 (#
b0 0#
b1 H"
b1 y"
b1 ##
b1 )$
b1 ?
1$
#526000
b100 @$
#530000
0$
#535000
b1 R#
b1 Z#
b1 _#
b1 g#
b1 l#
b1 t#
b10100 3
b10100 '$
b1 }"
b1 P#
b1 X#
b1 ,#
b1 ]#
b1 e#
b0 9#
b0 j#
b0 r#
b1 G#
b11 T#
b100 a#
b101 n#
b10 ?
b10 )$
1$
#536000
b0 %
b0 .
0&
#540000
0$
#545000
b11000 3
b11000 '$
b1 n#
b1 a#
b1 T#
b11 )$
b11 ?
1$
#550000
0$
#555000
0=
b1100 3
b1100 '$
b11 %$
11
15
0@
0>
b0 ?
0"
1($
1:
b0 )$
1$
#560000
0$
#565000
1/$
14
19
12
11
05
1=
0:
b11 &$
1>
1@
1$
#570000
0$
#575000
b10000 3
b10000 '$
b1100 b
b1100 j
b0 X
1W
b1 ?
1"
0($
b11000 B#
b11000 J#
b10100 k"
b10100 s"
b10000 6"
b10000 >"
b1100 _
b1100 g
1$
#576000
b0 B$
b10 A$
b10000 >$
b10 ?$
#580000
0$
#585000
b10000 F"
b10000 N"
b1100 9"
b1100 A"
b10100 3
b10100 '$
b1 X
b11000 F#
b11000 O#
b11000 W#
b10100 o"
b10100 x"
b10100 "#
b10000 :"
b10000 C"
b10000 K"
b1100 d
b1100 7"
b1100 ?"
b1100 c
b1100 l
b1100 t
b10 ?
1$
#586000
b1 B$
b10 )
b10 0
b10 .$
b10 6$
1*
#590000
0$
#595000
b1100 n"
b1100 v"
b10000 {"
b10000 %#
b10100 *#
b10100 2#
b11000 3
b11000 '$
b1100 p
b1100 y
b1100 #"
b1100 ;"
b1100 l"
b1100 t"
b10000 H"
b10000 y"
b10000 ##
b10000 G"
b10000 P"
b10000 X"
b10100 |"
b10100 '#
b10100 /#
b11000 S#
b11000 \#
b11000 d#
b10 X
b11 ?
b1 1$
1$
#596000
b10 B$
b0 )
b0 0
b0 .$
b0 6$
#600000
0$
#605000
b11000 l#
b11000 t#
b10100 _#
b10100 g#
b10000 R#
b10000 Z#
b1100 E#
b1100 M#
0=
b1100 3
b1100 '$
b11 X
b11000 `#
b11000 i#
b11000 q#
b10100 ,#
b10100 ]#
b10100 e#
b10100 +#
b10100 4#
b10100 <#
b10000 }"
b10000 P#
b10000 X#
b1100 p"
b1100 C#
b1100 K#
b10000 T"
b10000 ]"
b10000 e"
b1100 }
b1100 ("
b1100 0"
b10 1$
0@
0>
b0 ?
1$
#606000
b11 B$
#610000
0$
#615000
b1100 ,"
b10000 a"
b10100 8#
b1100 G#
b10000 T#
b10100 a#
b11000 n#
b11000 m#
b100 X
b11 1$
1$
#616000
b100 B$
#620000
0$
#625000
b101 X
b100 1$
1$
#626000
b101 B$
#630000
0$
#635000
b110 X
b101 1$
1$
#636000
b110 B$
b10 )
b10 0
b10 .$
b10 6$
#640000
0$
#645000
b100 %$
11
19
12
14
1;
0W
b110 1$
1$
#646000
b111 B$
b0 )
b0 0
b0 .$
b0 6$
#650000
0$
#655000
11
09
02
14
0;
b0 X
1W
1!
1,$
b100 &$
b111 1$
b11000 +$
b100 -$
1$
#656000
b1000 B$
#660000
0$
#665000
b1 X
b1000 1$
1$
#666000
b1001 B$
#670000
0$
#675000
b10 X
b1001 1$
1$
#676000
b1010 B$
#680000
0$
#685000
b11 X
b1010 1$
1$
#686000
b1011 B$
b10 )
b10 0
b10 .$
b10 6$
#690000
0$
#695000
b100 X
b1011 1$
1$
#696000
b1100 B$
b0 )
b0 0
b0 .$
b0 6$
#700000
0$
#705000
b101 X
b1100 1$
1$
#706000
b1101 B$
#710000
0$
#715000
b110 X
b1101 1$
1$
#716000
b1110 B$
#720000
0$
#725000
11
14
1;
0W
b1110 1$
1$
#726000
b1111 B$
#730000
0$
#735000
11
14
0;
b1111 1$
b11000 +$
b100 -$
1$
#736000
b10000 B$
b10 )
b10 0
b10 .$
b10 6$
#740000
0$
#745000
11
14
1/
17
b0 1$
1$
#746000
b10 ,
b101010000110001001011010100110000110001 G$
b0 )
b0 0
b0 .$
b0 6$
0*
#750000
0$
#755000
b101 %$
11
14
0/
1#$
07
1$
#756000
1'
#760000
0$
#765000
08$
0/$
b110 %$
01
04
b101 &$
0!
0,$
1$
#766000
b0 @$
0'
#770000
0$
#775000
b10 %$
b110 &$
1$
#776000
b1 @$
b1 %
b1 .
1&
#780000
0$
#785000
b11000 b
b11000 j
b10 a
b10 i
b100 5$
b100 4$
b110000 l#
b110000 t#
b10100 _#
b10100 g#
b10000 R#
b10000 Z#
b1100 E#
b1100 M#
b0 7#
b0 ?#
b101000 *#
b101000 2#
b10000 {"
b10000 %#
b1100 n"
b1100 v"
b0 `"
b0 h"
b0 S"
b0 ["
b100000 F"
b100000 N"
b1100 9"
b1100 A"
b0 +"
b0 3"
b0 |
b0 &"
b0 o
b0 w
10$
b10 k#
b10 s#
b0 ^#
b0 f#
b0 Q#
b0 Y#
b0 D#
b0 L#
b0 6#
b0 >#
b10 )#
b10 1#
b0 z"
b0 $#
b0 m"
b0 u"
b0 _"
b0 g"
b0 R"
b0 Z"
b10 E"
b10 M"
b0 8"
b0 @"
b0 *"
b0 2"
b0 {
b0 %"
b0 n
b0 v
11
15
18
b10 $$
0<
0#$
b10 &$
1$
#786000
b10 @$
#790000
0$
#795000
b11000 9"
b11000 A"
b100000 {"
b100000 %#
b101000 _#
b101000 g#
1=
b11000 d
b11000 7"
b11000 ?"
b100000 H"
b100000 y"
b100000 ##
b101000 ,#
b101000 ]#
b101000 e#
b110000 n#
1>
1@
1$
#796000
b11 @$
#800000
0$
#805000
b100000 R#
b100000 Z#
b11000 n"
b11000 v"
b10000 3
b10000 '$
b101000 a#
b100000 }"
b100000 P#
b100000 X#
b11000 ;"
b11000 l"
b11000 t"
b1 )$
b1 ?
1$
#806000
b100 @$
#810000
0$
#815000
b11000 E#
b11000 M#
b10100 3
b10100 '$
b11000 p"
b11000 C#
b11000 K#
b100000 T#
b10 ?
b10 )$
1$
#816000
b101010000110001001011010100110000110010 G$
b110000 F$
b101000 E$
b100000 D$
b11000 C$
b0 %
b0 .
0&
#820000
0$
#825000
b11000 3
b11000 '$
b11000 G#
b11 )$
b11 ?
b1 -
1$
#830000
0$
#835000
0=
b1100 3
b1100 '$
b11 %$
11
15
0@
0>
b0 ?
0"
1($
1:
b0 )$
b10 -
1$
#840000
0$
#845000
19
12
11
05
1=
0:
b11 &$
1>
1@
b11 -
1$
#850000
0$
#855000
b10000 3
b10000 '$
b0 X
1W
b1 ?
1"
0($
b100 -
1$
#860000
0$
#865000
b10100 3
b10100 '$
b1 X
b10 ?
b101 -
1$
#870000
0$
#875000
b11000 3
b11000 '$
b10 X
b11 ?
b110 -
1$
#880000
0$
#885000
0=
b1100 3
b1100 '$
b11 X
0@
0>
b0 ?
b111 -
1$
#890000
0$
#895000
b100 X
b1000 -
1$
#900000
0$
#905000
b101 X
b1001 -
1$
#910000
0$
#915000
b110 X
b1010 -
1$
#920000
0$
#925000
b100 %$
11
19
12
1;
0W
b1011 -
1$
#930000
0$
#935000
b101 %$
11
09
02
0;
b0 X
1W
1!
1,$
b100 &$
b110000 +$
b100 -$
b1100 -
1$
#940000
0$
#945000
00$
b110 %$
01
b1 X
b101 &$
b11 ,
b1101 -
1$
#950000
0$
#955000
b0 %$
b10 X
b110 &$
1$
#956000
1'
#960000
0$
#965000
b11000 l#
b11000 t#
b10100 *#
b10100 2#
b10000 F"
b10000 N"
b1100 b
b1100 j
b1 k#
b1 s#
b1 )#
b1 1#
b1 E"
b1 M"
b1 a
b1 i
b1 %$
b0 3
b0 '$
b11 X
08
b0 $$
1<
b0 &$
0A
0!
0,$
1$
#966000
0'
