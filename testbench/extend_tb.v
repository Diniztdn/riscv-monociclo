module extend_tb;

    reg [31:7] instr;
    reg [1:0] immsrc;

    wire [31:0] immext;

    //Instanciação da Extend Unit.
    extend uut(
        .instr(instr),
        .immsrc(immsrc),
        .immext(immext)
    );

    //Tarefa para verificar os resultados.
    task check_result;
        input [31:0] expected;

        begin
            #1;

            if (immext === expected)
                $display("Sucesso: immsrc=%b | Resultado=%h",
                         immsrc, immext);
            else
                $display("Falha: immsrc=%b | Obtido=%h | Esperado=%h",
                         immsrc, immext, expected);
        end
    endtask

    initial begin

        instr = 0;
        immsrc = 0;

        //TESTES TIPO I.

        //Imediato positivo: 0x123.
        instr = 0;
        instr[31:20] = 12'h123;
        immsrc = 2'b00;

        check_result(32'h00000123);

        //Imediato negativo: -1.
        instr = 0;
        instr[31:20] = 12'hFFF;
        immsrc = 2'b00;

        check_result(32'hFFFFFFFF);

        //TESTES TIPO S.

        //Imediato positivo: 0x123.
        instr = 0;
        instr[31:25] = 7'b0001001;
        instr[11:7] = 5'b00011;
        immsrc = 2'b01;

        check_result(32'h00000123);

        //Imediato negativo: -1.
        instr = 0;
        instr[31:25] = 7'b1111111;
        instr[11:7] = 5'b11111;
        immsrc = 2'b01;

        check_result(32'hFFFFFFFF);

        //TESTES TIPO B.

        //Imediato positivo: 10.
        instr = 0;
        instr[11:8] = 4'b0101;
        immsrc = 2'b10;

        check_result(32'h0000000A);

        //Imediato negativo: -4.
        instr = 0;
        instr[31] = 1'b1;
        instr[7] = 1'b1;
        instr[30:25] = 6'b111111;
        instr[11:8] = 4'b1110;
        immsrc = 2'b10;

        check_result(32'hFFFFFFFC);

        //TESTES TIPO J.

        //Imediato positivo: 4094.
        instr = 0;
        instr[20] = 1'b1;
        instr[30:21] = 10'b1111111111;
        immsrc = 2'b11;

        check_result(32'h00000FFE);

        //Imediato negativo: -2.
        instr = 0;
        instr[31] = 1'b1;
        instr[19:12] = 8'hFF;
        instr[20] = 1'b1;
        instr[30:21] = 10'b1111111111;
        immsrc = 2'b11;

        check_result(32'hFFFFFFFE);

        $display("--------------------------------");
        $display("Fim dos testes da Extend Unit.");

        $finish;

    end

endmodule