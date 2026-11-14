module alu_tb;

    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] ALUControl;

    wire [31:0] Result;
    wire Zero;

    alu uut(
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin

        A = 32'd10;
        B = 32'd5;

        ALUControl = 3'b000;
        #10;
        $display("ADD: %d", Result);

        ALUControl = 3'b001;
        #10;
        $display("SUB: %d", Result);

        ALUControl = 3'b010;
        #10;
        $display("AND: %d", Result);

        ALUControl = 3'b011;
        #10;
        $display("OR: %d", Result);

        ALUControl = 3'b101;
        #10;
        $display("SLT: %d", Result);

        $finish;
    end

endmodule