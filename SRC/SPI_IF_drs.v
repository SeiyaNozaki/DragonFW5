/*******************************************************************************
*                                                                              *
* Module      : M25P16_IF                                                      *
* Version     : v 0.0.0 2012/04/23                                             *
*                                                                              *
* Description : SPI flash rom M25P16 Interface                                 *
*                                                                              *
* Designer    : Tomohisa Uchida                                                *
*                                                                              *
*                Copyright (c) 2012 Tomohisa Uchida                            *
*                All rights reserved                                           *
*                                                                              *
*******************************************************************************/
`define SYN_DATE 32'h1204_2506

module SPI_IF_drs(
   CLK        ,  // in  : Clock
   RST        ,  // in  : System reset
   // RBCP I/F
   RBCP_ACT   ,  // in  : Active
   RBCP_ADDR  ,  // in  : Address[11:0]
   RBCP_WD    ,  // in  : Data[7:0]
   RBCP_WE    ,  // in  : Write enable
   RBCP_RE    ,  // in  : Read enable
   RBCP_ACK   ,  // out : Access acknowledge
   RBCP_RD    ,  // out : Read data[7:0]
   //
   STS_REG04X ,  // in  : General inputs
   div_value  ,  // in  :
   prog_start ,  // out :
   ledtgl     ,
   // SPI I/F
   SPI_SCK    ,  // out : Clock
   SPI_MISO   ,  // in  : Serial data input
   SPI_MOSI   ,  // out : Serial data output
   SPI_SS        // out : Chip select
);

//-------- Input/Output -------------
   input          CLK ;
   input          RST ;

   input          RBCP_ACT  ;
   input  [11:0]  RBCP_ADDR ;
   input  [7:0]   RBCP_WD   ;
   input          RBCP_WE   ;
   input          RBCP_RE   ;
   output         RBCP_ACK  ;
   output [7:0]   RBCP_RD   ;

   input  [7:0]   STS_REG04X ;
   input  [1:0]   div_value  ; // 2'd1:div2  2'd2,0:div8  2'd3:div16
   output         prog_start ;
   output         ledtgl     ;

   output         SPI_SCK  ;
   input          SPI_MISO ;
   output         SPI_MOSI ;
   output         SPI_SS   ;

//------------------------------------------------------------------------------
// Input buffer
//------------------------------------------------------------------------------
   reg    [11:0]  irAddr ;
   reg            irWe   ;
   reg            irRe   ;
   reg    [7:0]   irWd   ;

   always@ (posedge CLK) begin
      irAddr[11:0] <= RBCP_ADDR[11:0];
      irWe         <= RBCP_ACT & RBCP_WE;
      irRe         <= RBCP_ACT & RBCP_RE;
      irWd[7:0]    <= RBCP_WD[7:0];
   end

   reg            regCs ;
   reg            bufCs ;
   reg            bufWe ;
   reg    [10:0]  bufWa ;
   reg            dlyWe ;
   reg            dlyRe ;
   reg    [7:1]   spiWe ;
   reg    [7:0]   spiWd ;
   reg    [4:1]   bufAe ;

   reg            progSe ;
   reg            ledEnb ;

   always@ (posedge CLK) begin
      regCs       <= ~irAddr[11];
      bufCs       <=  irAddr[11];
      bufWe       <=  irAddr[11] & irWe;
      bufWa[10:0] <=  irAddr[10:0];

      dlyWe    <= irWe;
      dlyRe    <= irRe;

      spiWe[1] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h05);
      spiWe[2] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h06);
      spiWe[3] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h07);

      spiWe[4] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h08);
      spiWe[5] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h09);
      spiWe[6] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h0A);
      spiWe[7] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h0B);

      bufAe[1] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h01);
      bufAe[2] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h02);
      bufAe[3] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h03);
      bufAe[4] <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h04);

      progSe   <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h1F);
      ledEnb   <= ~irAddr[11] & irWe & (irAddr[4:0]==5'h1D);

      spiWd[7:0] <= irWd[7:0];
   end

   reg    [1:0]   dlyBufRe ;

   always@ (posedge CLK) begin
      dlyBufRe[1:0] <= {dlyBufRe[0],dlyRe & bufCs};
   end

//------------------------------------------------------------------------------
// Receive
//------------------------------------------------------------------------------
   wire   [31:0]  fpgaVer ;

   assign fpgaVer[31:0] = `SYN_DATE;

   reg    [7:0]   rdDataA ;
/* reg    [7:0]   rdDataB ;
   reg    [7:0]   rdDataC ;
   reg    [7:0]   rdDataD ;
   reg    [7:0]   rdDataE ;
   reg    [7:0]   rdDataF ;
   reg    [7:0]   rdDataG ;
   reg    [7:0]   rdDataH ;
   reg            regAck  ;
   reg    [1:0]   smonAck ;
   reg    [15:0]  rdDataI ;

   reg    [7:0]   rd_data_s2 ;*/

   reg    [3:0]   cmdLen   ;
   reg    [3:0]   cntrlBit ;
   reg    [15:0]  totalLen ;
   reg    [7:0]   cmdWord  ;
   reg    [23:0]  addrWord ;

   always@ (posedge CLK) begin
      case(irAddr[3:0])
         4'h0 : rdDataA[7:0] <= fpgaVer[31:24];
         4'h1 : rdDataA[7:0] <= fpgaVer[23:16];
         4'h2 : rdDataA[7:0] <= fpgaVer[15: 8];
         4'h3 : rdDataA[7:0] <= fpgaVer[ 7: 0];
         4'h4 : rdDataA[7:0] <= STS_REG04X[7:0];
         4'h5 : rdDataA[7:0] <= {cntrlBit[3:0],cmdLen[3:0]};
         4'h6 : rdDataA[7:0] <= totalLen[15:8];
         4'h7 : rdDataA[7:0] <= totalLen[7:0];
         4'h8 : rdDataA[7:0] <= cmdWord[7:0];
         4'h9 : rdDataA[7:0] <= addrWord[23:16];
         4'hA : rdDataA[7:0] <= addrWord[15:8];
         4'hB : rdDataA[7:0] <= addrWord[7:0];
         4'hC : rdDataA[7:0] <= 8'd0;
         4'hD : rdDataA[7:0] <= 8'd0;
         4'hE : rdDataA[7:0] <= 8'd0;
         4'hF : rdDataA[7:0] <= 8'd0;
      endcase
   end

   reg            orAck  ;
   reg    [7:0]   orRd   ;

   reg            spiAck ;
   wire   [7:0]   bufRd  ;

   always@ (posedge CLK) begin
      orAck     <= regCs & (dlyWe & ~spiWe[7] | dlyRe) | spiAck | dlyBufRe[1] | bufWe ;
      orRd[7:0] <= (regCs & dlyRe ? rdDataA[7:0] : 8'd0) | (dlyBufRe[1] ? bufRd[7:0] : 8'd0);
   end

   assign RBCP_ACK     = orAck;
   assign RBCP_RD[7:0] = orRd[7:0];

//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------
   always@ (posedge CLK or posedge RST) begin
      if(RST)begin
         cntrlBit[3:0]  <= 4'd0  ;
         cmdLen[3:0]    <= 4'd0  ;
         totalLen[15:0] <= 16'd0 ;
         cmdWord[7:0]   <= 8'd0  ;
         addrWord[23:0] <= 24'd0 ;
      end else begin
         if(spiWe[1])begin
            {cntrlBit[3:0],cmdLen[3:0]} <= spiWd[7:0];
         end
         if(spiWe[2])begin
            totalLen[15:8] <= spiWd[7:0];
         end
         if(spiWe[3])begin
            totalLen[7:0] <= spiWd[7:0];
         end
         if(spiWe[4])begin
            cmdWord[7:0] <= spiWd[7:0];
         end
         if(spiWe[5])begin
            addrWord[23:16] <= spiWd[7:0];
         end
         if(spiWe[6])begin
            addrWord[15:8] <= spiWd[7:0];
         end
         if(spiWe[7])begin
            addrWord[7:0] <= spiWd[7:0];
         end
      end
   end


   reg    [15:0]  bufWAddr ;
   reg    [15:0]  bufRAddr ;

   always@ (posedge CLK or posedge RST) begin
      if(RST)begin
         bufWAddr[15:0] <= 16'd0 ;
         bufRAddr[15:0] <= 16'd0 ;
      end else begin
         if (bufAe[1]) begin
            bufWAddr[15:8] <= spiWd[7:0] ;
         end
         if (bufAe[2]) begin
            bufWAddr[7:0]  <= spiWd[7:0] ;
         end
         if (bufAe[3]) begin
            bufRAddr[15:8] <= spiWd[7:0] ;
         end
         if (bufAe[4]) begin
            bufRAddr[7:0]  <= spiWd[7:0] ;
         end
      end
   end

   reg    [3:0]   adjCmdLen ;

   always@ (posedge CLK) begin
      adjCmdLen[3:0] <= (cntrlBit[3] ? cmdLen[3:0] : cmdLen[3:0] + 4'd1);
   end

   reg            startRd ;

   always@ (posedge CLK or posedge RST) begin
      if(RST)begin
         startRd <= 1'b0;
      end else begin
         startRd <= spiWe[7];
      end
   end

   reg            startRd2 ;

   always@(posedge CLK) begin
      startRd2 <= startRd ;
   end

   reg            sftEnb ;
   reg            sftLd  ;

   wire           sftEnd ;

   always@ (posedge CLK or posedge RST) begin
      if(RST)begin
         sftEnb <= 1'b0;
         sftLd  <= 1'b0;
      end else begin
         sftEnb <= ~sftEnd & (startRd2 | sftEnb);
         sftLd  <= startRd2;
      end
   end

   reg    [23:0]  sftCntr       ;

   always@ (posedge CLK or posedge RST) begin
      if(RST)begin
         sftCntr[23:0] <= 24'd0;
      end else begin
         if(sftEnb)begin
            sftCntr[23:0] <= sftCntr[23:0] - 24'd1;
         end else begin
            if (div_value[1:0]==2'd1) begin
               sftCntr[23:0] <= {4'b0,totalLen[15:0],4'b1101};  // div2
            end else if (div_value[1:0]==2'd2) begin
               if (startRd) begin
                  sftCntr[23:0] <= {2'b0,totalLen[15:0],6'b111110};  // div8
               end else begin
                  sftCntr[23:0] <= {2'b0,totalLen[15:0],6'b111101};  // div8
               end
            end else if (div_value[1:0]==2'd3) begin
               sftCntr[23:0] <= {1'b0,totalLen[15:0],7'b1111101};  // div16
            end else if (div_value[1:0]==2'd0) begin
               if (startRd) begin
                  sftCntr[23:0] <= {2'b0,totalLen[15:0],6'b111110};  // div8
               end else begin
                  sftCntr[23:0] <= {2'b0,totalLen[15:0],6'b111101};  // div8
               end
            end
         end
      end
   end

   assign sftEnd = sftCntr[23] & ~sftCntr[0];

   always@ (posedge CLK) begin
      spiAck <= (sftCntr[23:0]==24'hFF_FFFF);
   end

   reg    [1:0]   dlySftEnb ;

   always@ (posedge CLK) begin
      dlySftEnb[1:0] <= {dlySftEnb[0],sftEnb};
   end

   reg             sftClk  ;
   reg             sftCs   ;
   reg    [31:0]   sftData ;
   reg             wdLd    ;

   reg    [7:0]    sftBit  ;
   reg    [7:0]    rxData  ;
   reg    [4:0]    cmdCntr ;
   reg             byteWe  ;
   reg             byteRe  ;
   reg             cmdEnb  ;
   reg    [10:0]   byteWa  ;
   reg    [10:0]   byteRa  ;

   wire            sftEnb1 ;
   wire            sftEnb2 ;
   wire            sftEnb3 ;

   assign sftEnb1 = (sftCntr[0]==1'b0)      & (div_value[1:0]==2'd1) ;
   assign sftEnb2 = (sftCntr[2:0]==3'b110)  & ((div_value[1:0]==2'd2) | (div_value[1:0]==2'd0)) ;
   assign sftEnb3 = (sftCntr[3:0]==4'b1110) & (div_value[1:0]==2'd3) ;

   reg             sftEnb_all ;

   always@(posedge CLK) begin
      sftEnb_all <= (sftEnb1 | sftEnb2 | sftEnb3) ;
   end

   always@ (posedge CLK) begin
      sftClk <=  ((sftCntr[0] & (div_value[1:0]==2'd1)) | (sftCntr[2] & ((div_value[1:0]==2'd2) | (div_value[1:0]==2'd0))) | (sftCntr[3] & (div_value[1:0]==2'd3))) ;
      sftCs  <= ~(|dlySftEnb[1:0]);

      wdLd <= sftBit[7] & cmdCntr[4] & cntrlBit[3];

      if(sftEnb_all)begin
         sftData[31:0]  <= (sftLd          ? {cmdWord[7:0],addrWord[23:0]} : 32'd0) |
                           (wdLd           ? {bufRd[7:0],24'd0}            : 32'd0) |
                           (~sftLd & ~wdLd ? {sftData[30:0],1'b0}          : 32'd0) ;
         sftBit[7:0] <= (sftLd ? 8'd1 : {sftBit[6:0],sftEnb & sftBit[7]});
         rxData[7:0] <= {rxData[6:0],SPI_MISO};
      end

      byteWe      <= ~cntrlBit[3] & cmdCntr[4] & dlySftEnb[0] & sftEnb_all & sftBit[7];
      byteRe      <=  cntrlBit[3] & cmdCntr[4] & dlySftEnb[0] & sftEnb_all & sftBit[7];
      cmdEnb      <= dlySftEnb[0] & sftEnb_all & sftBit[5];

      if(sftLd)begin
         cmdCntr[4:0]   <= {1'b0,adjCmdLen[3:0]};
      end else begin
         if(cmdEnb)begin
            cmdCntr[4:0]   <= (cmdCntr[4] ? 5'h1F : cmdCntr[4:0] - 5'd1);
         end
      end

      if(sftLd)begin
         byteWa[10:0]   <= bufWAddr[10:0];
      end else begin
         if(byteWe)begin
            byteWa[10:0]   <= byteWa[10:0]+11'd1;
         end
      end

      if(sftLd)begin
         byteRa[10:0]   <= bufRAddr[10:0];
      end else begin
         if(byteRe)begin
            byteRa[10:0]   <= byteRa[10:0]+11'd1;
         end
      end
   end

   wire           SPI_SCK  ;
   wire           SPI_MOSI ;
   wire           SPI_SS   ;

   assign SPI_SCK  = sftClk      ;
   assign SPI_MOSI = sftData[31] ;
   assign SPI_SS   = sftCs       ;

   reg    [10:0]  memWa ;
   reg            memWe ;
   reg    [7:0]   memWd ;
   reg    [10:0]  memRa ;

   always@ (posedge CLK) begin
      memWa[10:0] <= (byteWe ? byteWa[10:0] : bufWa[10:0]);
      memWe       <= bufWe | byteWe;
      memWd[7:0]  <= (byteWe ? rxData[7:0] : spiWd[7:0]);

      memRa[10:0] <= (irRe ? irAddr[10:0] : byteRa[10:0]);
   end

   BMEM_DP_OR #(
   // Parameters
      .depth         (2048),
      .address_width (11),
      .data_width    (8)
   ) RD_BUF(
      .clka       (CLK           ), // in  : Clock
      .addra      (memWa[10:0]   ), // in  : address
      .wea        (memWe         ), // in  : Write enable
      .dia        (memWd[7:0]    ), // in  : Write data
      .clkb       (CLK           ), // in  : Clock
      .addrb      (memRa[10:0]   ), // in  : address
      .resb       (bufRd[7:0]    )  // out : read data
   );

//****************************************************************
//                    Configuration Start
//****************************************************************
   reg    [7:0]   progbuf        ;
   reg            dly_progSe     ;
   reg            reg_prog_start ;

   always@ (posedge CLK) begin
      if (progSe) begin
         progbuf[7:0] <= spiWd[7:0] ;
      end else begin
         progbuf[7:0] <= 8'd0 ;
      end
   end

   always@(posedge CLK) begin
      dly_progSe <= progSe ;
   end

   always@(posedge CLK) begin
      if (dly_progSe) begin
         reg_prog_start <= (progbuf[7:0]==8'hFF) ;
      end else begin
         reg_prog_start <= 1'b0 ;
      end
   end

   assign prog_start = reg_prog_start ;

//****************************************************************
//                    Configuration Start
//****************************************************************
   reg    [7:0]   ledbuf     ;
   reg            dly_ledEnb ;
   reg            reg_ledtgl ;

   always@ (posedge CLK) begin
      if (ledEnb) begin
         ledbuf[7:0] <= spiWd[7:0] ;
      end else begin
         ledbuf[7:0] <= 8'd0 ;
      end
   end

   always@(posedge CLK) begin
      dly_ledEnb <= ledEnb ;
   end

   always@(posedge CLK) begin
      if (dly_ledEnb) begin
         reg_ledtgl <= (ledbuf[7:0]==8'hF0) ;
      end else begin
         reg_ledtgl <= 1'b0 ;
      end
   end

   assign ledtgl = reg_ledtgl ;

endmodule

