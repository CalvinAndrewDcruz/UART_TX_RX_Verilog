module uart_top(
    input        clk,
    input        rx,
    input        tx_dv,
    input  [7:0] tx_byte,

    output       tx,
    output       rx_dv,
    output [7:0] rx_byte
);

uart_tx TX(
    .i_Clock(clk),
    .i_TX_DV(tx_dv),
    .i_TX_Byte(tx_byte),
    .o_TX_Active(),
    .o_TX_Serial(tx),
    .o_TX_Done()
);

uart_rx RX(
    .i_Clock(clk),
    .i_RX_Serial(tx),
    .o_RX_DV(rx_dv),
    .o_RX_Byte(rx_byte)
);

endmodule