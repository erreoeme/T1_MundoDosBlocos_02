Repositório com o código do planner, e definição do mundo dos blocos para planejamento de ações no mundo dos blocos refenciado no livro de Bratko "Prolog Programming for Artificial Intelligence"

Como rodar:

Estava rodando com a funcao "testarPlano" trocando apenas o estado inicial e o final na própria função, e consultando: testarPlano(X).

Exemplo de saída experada: ?- testarPlano(X). X = [move(d, at(2, 0), at(3, 0))]

Obs: Testamos na situação 3: do estado s6 -> s7 obtivemos 0,5 segundos para achar 1 ação. do estado s4 (igual ao s5) -> s7 obtivemos 45 segundos para achar 2 ações. do estado s3 -> s7, não conseguimos rodar, pois o planer passou mais de 30 minutos calculando e não chegava em uma conclusão. acreditamos que pelo tempo ser exponencial no número de ações, ainda demoraria muito tempo para rodar para esse caso.

Equipe:  
Pedro Miguel   
Ricardo Bonfim   
Rômulo José  
