# Instruções para a IA que trabalha neste repositório

> Este arquivo é lido por assistentes de código (Claude Code, Cursor, Copilot, Codex e
> similares). Ele existe porque **a IA da sua equipe também é avaliada pelo que escreve
> aqui**: o charter, o README e os commits entram na avaliação.

Você está ajudando uma equipe de estudantes no **Hackathon de Impacto Social**. Leia o
`CHARTER.md` antes de propor qualquer coisa.

## ⚠️ A regra que mais pesa: não declare funcionando o que não roda

O `CHARTER.md` tem uma tabela **`Está funcionando` × `Ainda não está`**. Ela é avaliada, e
a banca **compara essa tabela com o que o protótipo realmente faz**.

- ⛔ **Nunca** marque um item como funcionando porque o código existe. Marque porque
  **você viu rodar**.
- ⛔ Nunca escreva "implementado", "pronto" ou "concluído" sobre algo que você não
  executou.
- ✅ Quando algo funcionar só em parte, **diga em que parte**. Escopo estreito declarado
  vale ponto; escopo largo insinuado tira ponto duas vezes, no diagnóstico e no protótipo.
- ✅ Se a equipe pedir para "deixar mais impressionante", ofereça melhorar **o que roda**,
  não a descrição do que não roda.

> *Por que isto é regra e não conselho:* declarar no charter algo que a demonstração não
> mostra derruba a nota no critério de protótipo **e** no de diagnóstico. É o erro mais
> caro que uma equipe comete, e quase sempre foi a IA que escreveu a frase.

## Licença e autoria

- A licença é **Apache-2.0** e vale **desde o primeiro commit**. Não sugira trocar.
- Ao trazer código de terceiro, **diga de onde veio** no `FERRAMENTAS.md`.
- Usar IA para construir **não é cópia** e é o objetivo do evento. Copiar solução pronta de
  outra competição **é** desclassificação.

## ⛔ O que nunca entra no repositório

Este repositório é **público desde o primeiro dia**.

- Chave de API, senha, token, string de conexão. Use `.env` (ignorado) e mantenha o
  `.env.example` com os nomes das variáveis e **sem valores**.
- **Dado pessoal de qualquer pessoa real.** Nome, e-mail, telefone, CPF, endereço,
  prontuário, foto identificável. Use dado de exemplo, inventado.
- ⚠️ Se a organização parceira mandar uma planilha real, **não commite**. Gere uma versão
  sintética com a mesma estrutura e trabalhe nela.
- Se algo assim já foi commitado, **avise a equipe imediatamente**: apagar o arquivo não
  apaga o histórico, e o repositório é público.

## Ferramentas

Toda ferramenta usada é declarada no `FERRAMENTAS.md`, sob pena de desclassificação.
Ao usar uma nova, **acrescente a linha**. Isso inclui você: registre qual assistente é.

## Commits

- Mensagem no imperativo, dizendo **o que muda e por quê**, em português.
- Commits pequenos e frequentes: o histórico é **prova de autoria e de progresso**, e a
  banca olha a jornada, não só o resultado.
- Não amontoe o trabalho de uma semana num commit só.

## Antes de pedir revisão ou de submeter

Rode `./scripts/checar-repo.sh` e resolva o que ele apontar.
