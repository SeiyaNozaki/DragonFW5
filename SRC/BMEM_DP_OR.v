/*******************************************************************************
*                                                                              *
* System      : None                                                           *
* Block       : None                                                           *
* Module      : BMEM_DP_OR                                                     *
* Version     : v 0.0.0 2006/07/06 22:25                                       *
*                                                                              *
* Description : Dual port memory                                               *
*               with optional output registers                                 *
* Designer    : Tomohisa Uchida                                                *
*                                                                              *
*                Copyright (c) 2006 Tomohisa Uchida                            *
*                All rights reserved                                           *
*                                                                              *
*******************************************************************************/
module BMEM_DP_OR(
// Parameters
// depth       = 2048;
// address_width  = 11;
// data_width     = 8;
   clka           ,  // in : Clock
   addra          ,  // in : address
   wea               ,  // in : Write enable
   dia               ,  // in : Write data
   clkb           ,  // in : Clock
   addrb          ,  // in : address
   resb              // out   : read data
);

   parameter   depth       = 2048;
   parameter   address_width  = 11;
   parameter   data_width     = 8;

   input                clka  ;
   input [address_width-1:0]  addra ;
   input                wea      ;
   input [data_width-1:0]  dia      ;
   input                clkb  ;
   input [address_width-1:0]  addrb ;
   output   [data_width-1:0]  resb  ;

   reg      [data_width-1:0]  resb        ;
   reg      [data_width-1:0]  RAM   [depth-1:0] ;
   reg      [data_width-1:0]  dob            ;

   always@ (posedge clka) begin
      if(wea == 1'b1)begin
         RAM[addra]  <= dia;
      end
   end

   always@ (posedge clkb) begin
      dob   <= RAM[addrb];
   end

   always@ (posedge clkb) begin
      resb  <= dob;
   end

//------------------------------------------------------------------------------
endmodule
