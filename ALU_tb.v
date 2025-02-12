module ALU_tb;

    reg clk;
    reg enable;
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] Opcode;
    wire [3:0] Result;
    wire Zero;

    // Instantiate the ALU
    ALU uut (
        .clk(clk),
        .enable(enable),
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .Result(Result),
        .Zero(Zero)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test cases
    initial begin
        // Initialize inputs
        enable = 1;
        A = 4'b0011;
        B = 4'b0101;
        Opcode = 3'b000; // ADD

        #20; // Wait for pipeline stages
        $display("ADD: A = %b, B = %b, Result = %b, Zero = %b", A, B, Result, Zero);

        Opcode = 3'b001; // SUB
        #20;
        $display("SUB: A = %b, B = %b, Result = %b, Zero = %b", A, B, Result, Zero);

        Opcode = 3'b010; // AND
        #20;
        $display("AND: A = %b, B = %b, Result = %b, Zero = %b", A, B, Result, Zero);

        Opcode = 3'b101; // NOT
        #20;
        $display("NOT: A = %b, Result = %b, Zero = %b", A, Result, Zero);

        // Disable clock gating
        enable = 0;
        #20;
        $display("Clock gating disabled: Result = %b, Zero = %b", Result, Zero);

        $finish;
    end

endmodule
