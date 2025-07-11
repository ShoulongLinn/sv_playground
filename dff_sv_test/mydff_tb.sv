`timescale 1ns/1ps
module mydff_tb;
logic clk;
logic rst;
logic [7:0]din;
logic [7:0]dout;
logic start_vld;

//clk
//---------------------------------------
always #10 clk = !clk;
//---------------------------------------

//task to inject data and check dout
//----------------------------------------
  task data_inject(input [7:0]data,input check_flag);
    din = data;
    start_vld = check_flag;
    #20;
endtask
//---------------------------------------

//sequence
//----------------------------------------
sequence dout_check(int delay);
    dout ==8'h1 ##delay dout ==8'h1 ##delay dout ==8'h3;
endsequence
//----------------------------------------

//property
//----------------------------------------
property fixed_sequence_check;
    @(posedge clk) disable iff (rst)
  start_vld |-> dout_check(1);
endproperty
property fixed_pattern_check(int data_check);
    @(posedge clk) disable iff (rst)
  start_vld |-> dout == data_check;
endproperty
//----------------------------------------

//testbench
//---------------------------------------
    initial begin
        clk = 1;
        din = 0;
        #100;
        data_inject(8'h1,1);
        assert property (fixed_pattern_check(8'h1))
            $display("Expected pattern 1 detected!");
        else $error("Expected pattern 1 not detected!");
        data_inject(8'h2,1);
        assert property (fixed_pattern_check(8'h2))
            $display("Expected pattern 2 detected!");
        else $error("Expected pattern 2 not detected!");
        data_inject(8'h3,1);
        assert property (fixed_pattern_check(8'h3))
            $display("Expected pattern 3 detected!");
        else $error("Expected pattern 3 not detected!");
        #100;
        $finish;
    end
//---------------------------------------

//assert
//---------------------------------------
//assert_fixed: assert property (fixed_sequence_check)
//  			 $display("Expected sequence 1->2->3 detected!");
//        else $error("Expected sequence 1->2->3 not detected!");
//---------------------------------------

//inst
//---------------------------------------
mydff dut(
    .clk (clk),
    .rst(rst),
    .din (din),
    .dout(dout)
);
//---------------------------------------
endmodule