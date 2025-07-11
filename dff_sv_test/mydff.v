module mydff(
  input clk,
  input rst,
  input [7:0]din,
  output reg [7:0]dout
);

 always@(posedge clk)begin
   if(rst)begin
     dout <= 8'h0;
   end
   else begin
     dout <= din;
   end
 end
endmodule