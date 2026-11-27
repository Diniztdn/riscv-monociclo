
`timescale 1ns/1ps

module uladec_tb;

    reg [1:0] ULAOp;
    reg [2:0] funct3;
    reg funct7b5;
    reg opb5;

    wire [2:0] ULAControl;

    integer erros;

    uladec uut(
        .ULAOp(ULAOp),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .opb5(opb5),
        .ULAControl(ULAControl)
    );

    task check_result;
        input [2:0] esperado;
        begin
            #1;

            if (ULAControl === esperado)
                $display("Sucesso: ULAOp=%b | funct3=%b | opb5=%b | funct7b5=%b | ULAControl=%b",
                         ULAOp, funct3, opb5, funct7b5, ULAControl);
            else begin
                erros = erros + 1;
                $display("Falha: ULAOp=%b | funct3=%b | opb5=%b | funct7b5=%b",
                         ULAOp, funct3, opb5, funct7b5);
                $display("  Obtido: %b | Esperado: %b",
                         ULAControl, esperado);
            end
        end
    endtask

    initial begin
        erros = 0;

        //ULAOp = 00: ADD (LW e SW).
        ULAOp = 2'b00;
        funct3 = 3'b000;
        opb5 = 0;
        funct7b5 = 0;
        check_result(3'b000);

        //ULAOp = 01: SUB (BEQ).
        ULAOp = 2'b01;
        funct3 = 3'b000;
        opb5 = 0;
        funct7b5 = 0;
        check_result(3'b001);

        //ULAOp = 10: operações tipos R e I.
        ULAOp = 2'b10;

        //ADD (Tipo R).
        funct3 = 3'b000;
        opb5 = 1;
        funct7b5 = 0;
        check_result(3'b000);

        //SUB (Tipo R).
        funct3 = 3'b000;
        opb5 = 1;
        funct7b5 = 1;
        check_result(3'b001);

        //ADDI com bit 30 do imediato igual a 1.
        funct3 = 3'b000;
        opb5 = 0;
        funct7b5 = 1;
        check_result(3'b000);

        //SLT.
        funct3 = 3'b010;
        opb5 = 1;
        funct7b5 = 0;
        check_result(3'b101);

        //AND.
        funct3 = 3'b111;
        opb5 = 1;
        funct7b5 = 0;
        check_result(3'b010);

        //OR.
        funct3 = 3'b110;
        opb5 = 1;
        funct7b5 = 0;
        check_result(3'b011);

        //ULAOp desconhecido.
        ULAOp = 2'b11;
        funct3 = 3'b110;
        opb5 = 0;
        funct7b5 = 0;
        check_result(3'b000);

        //funct3 não reconhecido.
        ULAOp = 2'b10;
        funct3 = 3'b001;
        opb5 = 0;
        funct7b5 = 0;
        check_result(3'b000);

        $display("--------------------------------");
        $display("Testes realizados: 10");
        $display("Falhas: %0d", erros);
        $display("Fim dos testes do ULA Decoder.");

        $finish;
    end

endmodule
