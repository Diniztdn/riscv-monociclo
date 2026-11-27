`timescale 1ns/1ps

module maindec_tb;

    reg [6:0] op;
    wire [1:0] ResultSrc, ImmSrc, ULAOp;
    wire MemWrite, Branch, ULASrc, RegWrite, Jump;
    wire [10:0] obtido;
    reg [10:0] esperado;
    integer i;
    integer erros;

    maindec uut(
        .op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ULASrc(ULASrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ULAOp(ULAOp)
    );

    assign obtido = {
        RegWrite, ImmSrc, ULASrc, MemWrite,
        ResultSrc, Branch, ULAOp, Jump
    };

    initial begin
        erros = 0;

        for (i = 0; i < 128; i = i + 1) begin
            op = i[6:0];

            //Ordem dos campos:
            //RegWrite_ImmSrc_ULASrc_MemWrite_
            //ResultSrc_Branch_ULAOp_Jump
            case (op)
                //LW.
                7'b0000011:
                    esperado = 11'b1_00_1_0_01_0_00_0;
                //SW.
                7'b0100011:
                    esperado = 11'b0_01_1_1_00_0_00_0;
                //Tipo R.
                7'b0110011:
                    esperado = 11'b1_00_0_0_00_0_10_0;
                //BEQ.
                7'b1100011:
                    esperado = 11'b0_10_0_0_00_1_01_0;
                //Tipo I.
                7'b0010011:
                    esperado = 11'b1_00_1_0_00_0_10_0;
                //JAL.
                7'b1101111:
                    esperado = 11'b1_11_0_0_10_0_00_1;
                default:
                    esperado = 11'b0;
            endcase

            #1;

            //Detecta tambem bits X ou Z nas saidas.
            if (obtido !== esperado) begin
                erros = erros + 1;
                $display("FALHA: opcode=%b", op);
                $display("  Obtido:   %b", obtido);
                $display("  Esperado: %b", esperado);
            end
        end

        $display("--------------------------------");
        $display("Testes aprovados: %0d/128", 128-erros);
        $display("Falhas: %0d", erros);
        $finish;
    end

endmodule