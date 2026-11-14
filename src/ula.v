module ula_add(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] Result
);

    assign Result = A + B;

endmodule


module ula_sub(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] Result,
    output wire Overflow
);

    assign Result = A - B;

    assign Overflow =
        (A[31] ^ B[31]) & (Result[31] ^ A[31]);

endmodule


module ula_and(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] Result
);

    assign Result = A & B;

endmodule


module ula_or(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] Result
);

    assign Result = A | B;

endmodule


module ula_slt(
    input wire [31:0] SubResult,
    input wire Overflow,
    output wire [31:0] Result
);

    assign Result = {
        31'b0,
        (SubResult[31] ^ Overflow)
    };

endmodule


module ula(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [2:0] ULAControl,
    output reg [31:0] Result,
    output wire Zero
);

    wire [31:0] AddResult;
    wire [31:0] SubResult;
    wire [31:0] AndResult;
    wire [31:0] OrResult;
    wire [31:0] SLTResult;

    wire Overflow;

    ula_add add_unit(
        .A(A),
        .B(B),
        .Result(AddResult)
    );

    ula_sub sub_unit(
        .A(A),
        .B(B),
        .Result(SubResult),
        .Overflow(Overflow)
    );

    ula_and and_unit(
        .A(A),
        .B(B),
        .Result(AndResult)
    );

    ula_or or_unit(
        .A(A),
        .B(B),
        .Result(OrResult)
    );

    ula_slt slt_unit(
        .SubResult(SubResult),
        .Overflow(Overflow),
        .Result(SLTResult)
    );

    always @(*) begin

        case (ALUControl)

            3'b000: Result = AddResult;
            3'b001: Result = SubResult;
            3'b010: Result = AndResult;
            3'b011: Result = OrResult;
            3'b101: Result = SLTResult;

            default: Result = 32'b0;

        endcase

    end

    assign Zero = (Result == 32'b0);

endmodule