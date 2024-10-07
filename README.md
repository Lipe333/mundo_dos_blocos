# Planejador em Prolog para o Mundo de Blocos

O código implementa um planejador para o mundo de blocos, onde blocos podem ser movidos entre posições e empilhados uns sobre os outros. O objetivo é encontrar uma sequência de movimentos que transforme o estado inicial em um estado que satisfaça todas as metas especificadas.

## Passo 1: executando o planejador

Com o código carregado no ambiente, executar o planejador para encontrar um plano que alcance as metas a partir do estado inicial.

1. Chame o predicado `solve/1` para encontrar o plano:

   ```prolog
   ?- solve(Plan).
   ```

2. O Prolog tentará encontrar um plano e exibirá o resultado para a variável `Plan`.

## Passo 2: interpretando os resultados

Se o planejador encontrar um plano, você verá algo como:

```prolog
Plan = [
    move(c, 1, a),
    move(d, a, 4),
    move(a, 4, d),
    move(b, 6, d)
]
```

Para imprimir o plano de forma mais legível, você pode usar o predicado `print_result/1`:

1. Após encontrar o plano, chame `print_result/1`:

   ```prolog
   ?- solve(Plan), print_result(Plan).
   ```

2. O Prolog irá imprimir cada ação no plano:

   ```prolog
   move(c, 1, a)
   move(d, a, 4)
   move(a, 4, d)
   move(b, 6, d)
   ```

### Explicação do plano

- **move(c, 1, a):** Move o bloco `c` do lugar `1` para cima do bloco `a`.
- **move(d, a, 4):** Move o bloco `d` de cima do bloco `a` para o lugar `4`.
- **move(a, 4, d):** Move o bloco `a` do lugar `4` para cima do bloco `d`.
- **move(b, 6, d):** Move o bloco `b` do lugar `6` para cima do bloco `d`.

### Verificando se as Metas Foram Alcançadas

As metas especificadas são:

- `on(c, a)`
- `on(a, d)`
- `on(b, d)`
- `on(d, 4)`
- `clear(1)`
- `clear(2)`
- `clear(3)`
- `clear(c)`

Após executar o plano, todas essas metas devem ser satisfeitas.

# Sessão para responder questões do pdf aqui

## 1. Com base nos exemplos das seções 2.3 e 3.2 do livro do Russel, faça uma formulação completa do problema do mundo dos blocos deste trabalho, e descreva

Esta seção contém a formulação do problema do mundo dos blocos, baseado nas seções 2.3 e 3.2 do livro *Artificial Intelligence: A Modern Approach* de Stuart Russell e Peter Norvig. A formulação inclui a tabela PEAS, estados e ações do agente, além da definição de estado inicial e metas.

### A. Tabela PEAS para o Mundo dos Blocos

Esta tabela segue o modelo PEAS (Desempenho, Ambiente, Atuadores e Sensores) ajustada para o mundo dos blocos:

| **Componente**  | **Descrição**                                                                                 |
|-----------------|-----------------------------------------------------------------------------------------------|
| **Desempenho**  | O agente deve empilhar corretamente os blocos de acordo com a configuração final (metas) desejada, mantendo a estabilidade das pilhas. O desempenho pode ser medido em termos de sucesso no cumprimento das metas (blocos na ordem correta e estáveis) e eficiência (número mínimo de movimentos). |
| **Ambiente**    | O ambiente é uma grade discreta que contém lugares para os blocos (cada posição na grade pode acomodar blocos de diferentes tamanhos). O ambiente é parcialmente observável, já que o agente pode precisar de ações de percepção (ex: sensores de visão) para ver o estado de blocos que estão encobertos. |
| **Atuadores**   | O agente possui atuadores que lhe permitem mover blocos de uma posição para outra na grade. Movimentos incluem levantar o bloco verticalmente, mover horizontalmente e abaixar o bloco para a nova posição. O agente deve garantir que os blocos sejam suportados corretamente nas novas posições. |
| **Sensores**    | Sensores que permitem ao agente perceber o estado do ambiente. Exemplo: detectar se uma posição está ocupada ou livre, identificar o tamanho do bloco em uma posição específica, e verificar se um bloco está em equilíbrio. Podem incluir sensores de visão (para detectar blocos encobertos ou empilhados). |

### B. Detalhamento: Estados, Atuadores e Ações

#### 1. Estados do Ambiente (Percepção do Agente)

- O agente percebe a disposição dos blocos na grade, onde cada célula pode estar:
  - **Livre** (sem bloco).
  - **Ocupada** por um bloco de tamanho específico.
  - **Empilhada**: Um bloco pode estar em cima de outro, o que também precisa ser percebido pelo agente.
- O agente também deve perceber se um bloco está **claro** (ou seja, se nenhum outro bloco está em cima dele, permitindo que ele seja movido).
- **Tamanho** dos blocos: blocos variam em tamanho (por exemplo, o bloco `d` ocupa 3 células, enquanto o bloco `a` ocupa 1 célula). O agente precisa considerar isso ao tentar mover um bloco.

#### 2. Atuadores e Ações do Agente

- **Movimento de Blocos**:
  - O agente pode **levantar** um bloco de uma célula (posição) e movê-lo verticalmente.
  - O agente pode **mover** o bloco horizontalmente ao longo de uma linha até alcançar a célula de destino.
  - O agente pode **abaixar** o bloco em outra célula da grade.
- **Restrições de Movimentos**:
  - O bloco só pode ser movido para uma célula **livre** e que forneça suporte suficiente (ou seja, o tamanho do bloco de destino deve ser adequado).
  - O agente não pode mover um bloco para uma célula onde já exista outro bloco.
  - O agente deve garantir que a posição final de um bloco seja estável (por exemplo, ao empilhar blocos, o bloco inferior deve ser grande o suficiente para suportar o bloco superior).

#### 3. Estado Inicial e Estado Final

- **Estado Inicial**:
  - O estado inicial é descrito pela disposição dos blocos no ambiente:
    - Exemplo: Bloco `c` (tamanho 2) na posição 1, bloco `a` (tamanho 1) na posição 4, bloco `b` (tamanho 1) na posição 6, e bloco `d` (tamanho 3) empilhado em cima dos blocos `a` e `b`.
  - Exemplo de estado inicial:

    ```prolog
    initial_state([clear(c),clear(2),clear(3),clear(d),clear(5),on(c,1),on(a,4),on(b,6),on(d,a),on(d,b)]).
    ```

- **Estado Final (Meta)**:
  - O objetivo é organizar os blocos de acordo com a disposição desejada, que geralmente é uma empilhagem ordenada e estável.
  - Exemplo de meta: Empilhar o bloco `c` em `a`, `a` em `d`, e `b` em `d`, com `d` ocupando a posição 4.
  - Exemplo de estado final (meta):

    ```prolog
    goals([on(c,a), on(a,d), on(b,d), on(d,4), clear(1), clear(2), clear(3), clear(c)]).
    ```

#### 4. Conceitos Necessários para uma Solução Geral

- **Representação em Grade**: O ambiente pode ser modelado como uma grade discreta, onde cada célula pode acomodar blocos de diferentes tamanhos. O menor bloco ocupa uma única célula e os maiores blocos podem ocupar múltiplas células adjacentes.
- **Movimentos Baseados em Condições**: O agente só pode mover blocos se eles estiverem **claros** (sem blocos em cima) e se o local de destino puder suportar o bloco, considerando seu tamanho.
- **Estabilidade de Pilhas**: Blocos empilhados devem ser estáveis, ou seja, blocos menores não podem ser a base de blocos maiores.
- **Ações de Percepção**: O agente deve ter sensores que permitam identificar o tamanho dos blocos, sua posição na grade e se eles estão em pilhas.

#### Conceito de Local Possível entre Blocos e Espaços Livres

- O bloco de menor tamanho ocupa uma única célula, mas blocos maiores (como `d`, que tem tamanho 3) ocupam múltiplas células adjacentes.
- Um **local possível** para um bloco é uma célula ou série de células adjacentes que estão livres e que podem suportar o bloco baseado em seu tamanho.
- O conceito de estabilidade deve ser respeitado. Por exemplo, ao mover o bloco `d` (tamanho 3) para um novo local, ele só pode ser movido para uma posição onde três células consecutivas estejam livres para garantir estabilidade.

## 2. Adaptar o código do planner da figura 17.6 do livro do Bratko, de tal maneira que este manipule corretamente variáveis sobre goals e também ações conforme discussão na sessão 17.5. Indique esta mudança com a explicação.

## 3. Considere a Situação 1 (página 4) e gere manualmente com sua linguagem, ou os passos do seu programa se conseguir, o plano ações para ir do estado.
Baseado nas ações fornecidas para cada situação, vamos descrever a interpretação de cada uma das sequências de movimentos:

### Sequência 1: estado *i1* até *i2*
1. **`move(d, a, c) at pos(1)`**: Mova `d` de cima de `a` para cima de `c` na posição 1.
2. **`move(a, 4, b) at pos(6)`**: Mova `a` da posição 4 para cima de `b` na posição 6.
3. **`move(d, c, 3)`**: Mova `d` de cima de `c` para a posição 3.
4. **`move(a, b, c) at pos(1)`**: Mova `a` de cima de `b` para cima de `c` na posição 1.

### Sequência 2: estado *i2* até *i2 (a)*
1. **`move(b, 6, c) at pos(2)`**: Mova `b` da posição 6 para cima de `c` na posição 2.
2. **`move(d, 3, 4)`**: Mova `d` da posição 3 para a posição 4.
3. **`move(b, c, d) at pos(6)`**: Mova `b` de cima de `c` para cima de `d` na posição 6.
4. **`move(a, c, d) at pos(5)`**: Mova `a` de cima de `c` para cima de `d` na posição 5.
5. **`move(c, 1, a) at pos(5)`**: Mova `c` da posição 1 para cima de `a` na posição 5.


### Sequência 3: estado *i2* até *i2 (b)*
1. **`move(b, 6, c) at pos(2)`**: Mova `b` da posição 6 para cima de `c` na posição 2.
2. **`move(d, 3, 4)`**: Mova `d` da posição 3 para a posição 4.
3. **`move(b, c, 3)`**: Mova `b` de cima de `c` para a posição 3.
4. **`move(a, c, b) at pos(6)`**: Mova `a` de cima de `c` para cima de `b` na posição 6.
5. **`move(c, 1, d) at pos(5)`**: Mova `c` da posição 1 para cima de `d` na posição 5.
6. **`move(a, b, 2)`**: Mova `a` de cima de `b` para a posição 2.
7. **`move(b, 3, c) at pos(6)`**: Mova `b` da posição 3 para cima de `c` na posição 6.
8. **`move(a, 2, c) at pos(6)`**: Mova `a` da posição 2 para cima de `c` na posição 6.


### Sequência 4: estado *i2* até *i2 (c)*
1. **`move(b, 6, c) at pos(2)`**: Mova `b` da posição 6 para cima de `c` na posição 2.
2. **`move(d, 3, 4)`**: Mova `d` da posição 3 para a posição 4.
3. **`move(a, c, 3)`**: Mova `a` de cima de `c` para a posição 3.
4. **`move(b, c, c) at pos(1)`**: Mova `b` de cima de `c` para cima de `c` na posição 1.
5. **`move(d, 4, c) at pos(2)`**: Mova `d` da posição 4 para cima de `c` na posição 2.
6. **`move(b, c, 6)`**: Mova `b` de cima de `c` para a posição 6.
7. **`move(d, c, c) at pos(1)`**: Mova `d` de cima de `c` para cima de `c` na posição 1.


### Sequência 5: estado *i1* até *i2*
Essa sequência é idêntica à Sequência 1:
1. **`move(d, a, c) at pos(1)`**: Mova `d` de cima de `a` para cima de `c` na posição 1.
2. **`move(a, 4, b) at pos(6)`**: Mova `a` da posição 4 para cima de `b` na posição 6.
3. **`move(d, c, 3)`**: Mova `d` de cima de `c` para a posição 3.
4. **`move(a, b, c) at pos(1)`**: Mova `a` de cima de `b` para cima de `c` na posição 1.
