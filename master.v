module master #(parameter ADDR_WIDTH=32, DATA_WIDTH=8)(
  input PCLK,
  input PRESETn,
  input [ADDR_WIDTH-1:0] ADDR,
  input [DATA_WIDTH-1:0] DATA,
  input data_trans,
  input PREADY,
  output PSEL,
  output [ADDR_WIDTH-1:0] PADDR,
  output [DATA_WIDTH-1:0] PWDATA,
  output PWRITE,
  output PENABLE
 );

  localparam IDLE=2'd0, SETUP=2'd1, ACCESS=2'd2;
  reg state,next_state;

  // Sequential logic for next state
  always @(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn)
        state<=IDLE;
      else
        state<=next_state;
    end

  //next state logic
  always @(*)
    begin
      case(state)
        IDLE:begin
          if(data_trans)
            next_state=SETUP;
        end
        SETUP:begin
          next_state=ACCESS;
        end
        ACCESS:begin
          if(!PREADY)
            next_state=ACCESS;
          else
            if(data_trans) // Will there be new data transfer or not
              next_state=SETUP;
            else
              next_state=IDLE;
          default: next_state=IDLE;
        end

    end

// PSEL logic

    always @(posedge PCLK or negedge RESETn)
      begin
        case(state)
          IDLE: PSEL<=0;
          SETUP: PSEL<=1;
          ACCESS: PSEL<=1;
          default: PSEL<=0;
      end
          

        
        
  
        
