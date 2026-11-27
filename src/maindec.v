module maindec(
    input wire [6:0] op,

    output wire [1:0] ResultSrc,
    output wire MemWrite,
    output wire Branch,
    output wire ULASrc,
    output wire RegWrite,
    output wire Jump,
    output wire [1:0] ImmSrc,
    output wire [1:0] ULAOp
);

    reg [10:0] controles;

    //Separando os sinais de controle.
    assign {
        RegWrite,
        ImmSrc,
        ULASrc,
        MemWrite,
        ResultSrc,
        Branch,
        ULAOp,
        Jump
    } = controles;

    always @(*) begin

        case (op)

            //LW.
            7'b0000011:
                controles = {
                    1'b1, 2'b00, 1'b1, 1'b0,
                    2'b01, 1'b0, 2'b00, 1'b0
                };

            //SW.
            7'b0100011:
                controles = {
                    1'b0, 2'b01, 1'b1, 1'b1,
                    2'b00, 1'b0, 2'b00, 1'b0
                };

            //Tipo R: ADD, SUB, SLT, AND, OR.
            7'b0110011:
                controles = {
                    1'b1, 2'b00, 1'b0, 1'b0,
                    2'b00, 1'b0, 2'b10, 1'b0
                };

            //BEQ.
            7'b1100011:
                controles = {
                    1'b0, 2'b10, 1'b0, 1'b0,
                    2'b00, 1'b1, 2'b01, 1'b0
                };

            //Tipo I: ADDI, ANDI, ORI, SLTI.
            7'b0010011:
                controles = {
                    1'b1, 2'b00, 1'b1, 1'b0,
                    2'b00, 1'b0, 2'b10, 1'b0
                };

            //JAL.
            7'b1101111:
                controles = {
                    1'b1, 2'b11, 1'b0, 1'b0,
                    2'b10, 1'b0, 2'b00, 1'b1
                };

            //Opcode desconhecido.
            default:
                controles = 11'b0;

        endcase

    end

endmodule