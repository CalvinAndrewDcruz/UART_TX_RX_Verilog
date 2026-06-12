//=========================================================
// UART TRANSMITTER
// 50 MHz Clock
// 9600 Baud Rate
//=========================================================

module uart_tx
#(
    parameter CLKS_PER_BIT = 5208
)
(
    input        i_Clock,
    input        i_TX_DV,
    input [7:0]  i_TX_Byte,

    output reg   o_TX_Active,
    output reg   o_TX_Serial,
    output reg   o_TX_Done
);

    //=====================================================
    // STATE MACHINE STATES
    //=====================================================
    localparam IDLE         = 3'b000;
    localparam TX_START_BIT = 3'b001;
    localparam TX_DATA_BITS = 3'b010;
    localparam TX_STOP_BIT  = 3'b011;
    localparam CLEANUP      = 3'b100;

    //=====================================================
    // REGISTERS
    //=====================================================
    reg [2:0]  r_SM_Main      = 0;
    reg [12:0] r_Clock_Count  = 0;
    reg [2:0]  r_Bit_Index    = 0;
    reg [7:0]  r_TX_Data      = 0;

    //=====================================================
    // MAIN FSM
    //=====================================================
    always @(posedge i_Clock)
    begin

        case (r_SM_Main)

        //=================================================
        // IDLE STATE
        //=================================================
        IDLE :
        begin
            o_TX_Serial   <= 1'b1;   // UART idle = HIGH
            o_TX_Done     <= 1'b0;
            o_TX_Active   <= 1'b0;
            r_Clock_Count <= 0;
            r_Bit_Index   <= 0;

            if (i_TX_DV == 1'b1)
            begin
                o_TX_Active <= 1'b1;
                r_TX_Data   <= i_TX_Byte;
                r_SM_Main   <= TX_START_BIT;
            end
            else
            begin
                r_SM_Main <= IDLE;
            end
        end

        //=================================================
        // START BIT
        //=================================================
        TX_START_BIT :
        begin
            o_TX_Serial <= 1'b0;

            if (r_Clock_Count < CLKS_PER_BIT-1)
            begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= TX_START_BIT;
            end
            else
            begin
                r_Clock_Count <= 0;
                r_SM_Main     <= TX_DATA_BITS;
            end
        end

        //=================================================
        // DATA BITS
        //=================================================
        TX_DATA_BITS :
        begin
            o_TX_Serial <= r_TX_Data[r_Bit_Index];

            if (r_Clock_Count < CLKS_PER_BIT-1)
            begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= TX_DATA_BITS;
            end
            else
            begin
                r_Clock_Count <= 0;

                if (r_Bit_Index < 7)
                begin
                    r_Bit_Index <= r_Bit_Index + 1;
                    r_SM_Main   <= TX_DATA_BITS;
                end
                else
                begin
                    r_Bit_Index <= 0;
                    r_SM_Main   <= TX_STOP_BIT;
                end
            end
        end

        //=================================================
        // STOP BIT
        //=================================================
        TX_STOP_BIT :
        begin
            o_TX_Serial <= 1'b1;

            if (r_Clock_Count < CLKS_PER_BIT-1)
            begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= TX_STOP_BIT;
            end
            else
            begin
                o_TX_Done     <= 1'b1;
                r_Clock_Count <= 0;
                r_SM_Main     <= CLEANUP;
            end
        end

        //=================================================
        // CLEANUP
        //=================================================
        CLEANUP :
        begin
            o_TX_Done   <= 1'b1;
            o_TX_Active <= 1'b0;
            r_SM_Main   <= IDLE;
        end

        //=================================================
        // DEFAULT
        //=================================================
        default :
            r_SM_Main <= IDLE;

        endcase
    end

endmodule