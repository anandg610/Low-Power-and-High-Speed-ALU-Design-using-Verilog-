module ALU (
    input wire clk,          // Clock signal
    input wire enable,       // Enable signal for clock gating
    input wire [3:0] A,      // 4-bit input A
    input wire [3:0] B,      // 4-bit input B
    input wire [2:0] Opcode, // 3-bit opcode for selecting operation
    output reg [3:0] Result, // 4-bit output result
    output reg Zero          // Zero flag (1 if Result is zero, 0 otherwise)
);

    // Opcode definitions
    localparam ADD  = 3'b000;
    localparam SUB  = 3'b001;
    localparam AND  = 3'b010;
    localparam OR   = 3'b011;
    localparam XOR  = 3'b100;
    localparam NOT  = 3'b101;

    // Internal signals for pipelining
    reg [3:0] A_reg, B_reg;
    reg [2:0] Opcode_reg;
    reg [3:0] Result_next;

    // Clock gating logic
    wire gated_clk;
    assign gated_clk = clk & enable; // Enable clock only when 'enable' is high

    // Pipeline Stage 1: Register inputs
    always @(posedge gated_clk) begin
        A_reg <= A;
        B_reg <= B;
        Opcode_reg <= Opcode;
    end

    // Pipeline Stage 2: Perform computation
    always @(*) begin
        case (Opcode_reg)
            ADD:  Result_next = A_reg + B_reg; // Addition
            SUB:  Result_next = A_reg - B_reg; // Subtraction
            AND:  Result_next = A_reg & B_reg; // Bitwise AND
            OR:   Result_next = A_reg | B_reg; // Bitwise OR
            XOR:  Result_next = A_reg ^ B_reg; // Bitwise XOR
            NOT:  Result_next = ~A_reg;        // Bitwise NOT
            default: Result_next = 4'b0000;   // Default case
        endcase
    end

    // Pipeline Stage 3: Register output
    always @(posedge gated_clk) begin
        Result <= Result_next;
        Zero <= (Result_next == 4'b0000) ? 1'b1 : 1'b0; // Zero flag logic
    end

endmodule
