# Planejador em Prolog para o Mundo de Blocos

O código implementa um planejador para o mundo de blocos, onde blocos podem ser movidos entre posições e empilhados uns sobre os outros. O objetivo é encontrar uma sequência de movimentos que transforme o estado inicial em um estado que satisfaça todas as metas especificadas.

## Passo 1: executando o planejador

Agora que o código está carregado, vamos executar o planejador para encontrar um plano que alcance as metas a partir do estado inicial.

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

## Sessão para responder questões do pdf aqui
