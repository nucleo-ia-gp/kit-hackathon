# Kit da equipe · Hackathon de Impacto Social

Ponto de partida do repositório da sua equipe. **Clone, preencha, construa.**
Ele já vem com o que o Edital exige, para você não perder tempo com forma e gastar o
tempo no problema.

⚠️ **Isto é material de apoio, não norma.** O que obriga está no Edital; onde houver
divergência, vale o Edital.

## Os 15 minutos iniciais

```bash
# 1. use este repositório como template (botão "Use this template" no GitHub)
# 2. deixe-o PÚBLICO desde o primeiro commit. É exigência, e é prova de autoria.
git clone <o-seu-repo> && cd <o-seu-repo>

# 3. preencha, nesta ordem
#    CHARTER.md      os 7 itens, com a tabela do item 4
#    FERRAMENTAS.md  o que vocês usam, e o link publicado

# 4. confira antes de pedir revisão ou submeter
./scripts/checar-repo.sh
```

## O que tem aqui, e por que cada coisa

| arquivo | para quê |
|---|---|
| `LICENSE` | **Apache-2.0**, exigida desde o primeiro commit |
| `CHARTER.md` | os 7 itens do charter, com a tabela **`Está funcionando × Ainda não`** |
| `FERRAMENTAS.md` | a declaração obrigatória, e as perguntas sobre o link publicado |
| **`AGENTS.md`** | ⭐ instruções para a **IA de vocês**. Leia antes de usar qualquer assistente |
| `.env.example` · `.gitignore` | o que nunca vai para um repositório público |
| `scripts/checar-repo.sh` | confere licença, segredo, charter e ferramentas |

## ⭐ O arquivo que quase ninguém tem: `AGENTS.md`

Assistentes de código leem esse arquivo. Ele instrui a IA da sua equipe a **não declarar
como funcionando o que não roda** e a **nunca commitar segredo ou dado pessoal**.

⇒ *Por que isso vale ponto:* a banca **compara a tabela do charter com o protótipo rodando**.
O erro mais caro, e o mais comum, é a IA escrever "implementado" sobre algo que existe no
código e não executa. Isso derruba a nota em dois critérios de uma vez.

## ⚠️ Três coisas que custam caro e são fáceis de evitar

1. **Segredo no histórico.** O repositório é público. Apagar o arquivo **não apaga o
   histórico**. Rode o `checar-repo.sh` antes de cada push.
2. **Dado real de pessoa.** Se a organização parceira mandar planilha com nome, telefone ou
   prontuário, **não commite**. Gere versão sintética com a mesma estrutura.
3. ⭐ **Link publicado com prazo de validade.** Alguns planos gratuitos derrubam o app
   depois de um tempo. **Confira o prazo** e, se houver, republique na semana do Demo Day.
   Grave também o vídeo do app rodando: ele satisfaz a exigência sozinho.

## O que o `checar-repo.sh` NÃO faz

Ele confere **forma, não mérito**. Verde aqui não diz nada sobre a qualidade da solução,
e a checagem de segredo é **varredura por padrão**: pega o que parece segredo, e um
segredo escrito de um jeito que ela não conhece passa.

⇒ Ele tem `--auto-teste`, que prova que a varredura **sabe reprovar** antes de você
confiar no verde dela.
